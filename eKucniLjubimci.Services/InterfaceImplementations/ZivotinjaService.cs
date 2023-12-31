﻿using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.ArtikalStateMachine;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using eKucniLjubimci.Services.NarudzbaStateMachine;
using eKucniLjubimci.Services.ZivotinjaStateMachine;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.CodeDom;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.InterfaceImplementations
{
    public class ZivotinjaService : BaseServiceCRUD<DtoZivotinja, Zivotinja, SearchZivotinja, AddZivotinja, UpdateZivotinja>, IZivotinjaService
    {
        BaseZivotinjaState _baseZivotinjaState;
        public ZivotinjaService(DataContext context, IMapper mapper, BaseZivotinjaState baseZivotinjaState) : base(context, mapper)
        {
            _baseZivotinjaState= baseZivotinjaState;
        }
        public override IQueryable<Zivotinja> AddInclude(IQueryable<Zivotinja> data, SearchZivotinja? search)
        {
            data = data.Include(x => x.Vrsta).ThenInclude(x=>x.Rasa).Include(x => x.Slike).OrderByDescending(x=>x.DatumPostavljanja);

            return base.AddInclude(data, search);
        }
        public override async Task<DtoZivotinja> GetById(int id)
        {
            var data = await _context.Set<Zivotinja>().Include(x=>x.Vrsta).ThenInclude(x => x.Rasa).Include(x=>x.Slike).FirstOrDefaultAsync(x=>x.ZivotinjaId==id);

            return _mapper.Map<DtoZivotinja>(data);
        }
        public override IQueryable<Zivotinja> AddFilter(IQueryable<Zivotinja> data, SearchZivotinja? search)
        {
            data = data.Where(x => x.StateMachine != "Deleted").Where(x=>x.Slike.Count>0);
            if (!string.IsNullOrWhiteSpace(search.Rasa))
            {
                data = data.Where(x => x.Vrsta.Rasa.Naziv.ToLower().Contains(search.Rasa.ToLower()));
            }
            if (!string.IsNullOrWhiteSpace(search.Vrsta))
            {
                data = data.Where(x => x.Vrsta.Naziv.Contains(search.Vrsta));
            }
            if (!string.IsNullOrWhiteSpace(search.Naziv))
            {
                data = data.Where(x => x.Naziv.Contains(search.Naziv));
            }
            if (search.CijenaDo != null && search.CijenaDo != 0)
            {
                data = data.Where(x => x.Cijena <= search.CijenaDo);
            }
            if (search.CijenaOd != null && search.CijenaOd != 0)
            {
                data = data.Where(x => x.Cijena >= search.CijenaOd);
            }
            if (search.Dostupnost==true)
            {
                data = data.Where(x => x.Dostupnost == search.Dostupnost);
            }
            if (search.VrstaId!=null)
            {
                data = data.Where(x => x.VrstaId == search.VrstaId);
            }
            return base.AddFilter(data, search);
        }

        public override async Task<DtoZivotinja> Add(AddZivotinja addRequest)
        {
            var state = _baseZivotinjaState.GetState(addRequest.StateMachine);
            return await state.Add(addRequest);
        }

        public override async Task<DtoZivotinja> Update(int id, UpdateZivotinja updateRequest)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(id);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.Update(id, updateRequest);
        }

        public async Task<DtoZivotinja> Activate(int id)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(id);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.Activate(id);
        }

        public async Task<DtoZivotinja> Delete(int id)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(id);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.Delete(id);
        }

        public async Task<List<string>> AllowedActions(int zivotinjaId)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(zivotinjaId);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.AllowedActionsInState();
        }

        public async Task<DtoZivotinja> Dostupnost(int id, bool dostupnost)
        {
            var zivotinja = await _context.Zivotinje.FindAsync(id);
            var state = _baseZivotinjaState.GetState(zivotinja.StateMachine);
            return await state.Dostupnost(id, dostupnost);
        }




        public List<DtoArtikal> RecommendItems(int id)
        {
            var obj = new Recommend(_context, _mapper);
            string baseDirectory = Directory.GetCurrentDirectory();
            string modelFilePath = Path.Combine(baseDirectory, "..", "PodaciRecommend.zip");            
            obj.TrainFunction(modelFilePath);            

            return obj.RecommendFunction(modelFilePath, id);
        }

    }
}
