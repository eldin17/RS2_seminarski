using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using eKucniLjubimci.Services.NarudzbaStateMachine;
using eKucniLjubimci.Services.ZivotinjaStateMachine;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
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
            data = data.Include(x => x.Vrsta).Include(x => x.Slike);

            return base.AddInclude(data, search);
        }
        public override IQueryable<Zivotinja> AddFilter(IQueryable<Zivotinja> data, SearchZivotinja? search)
        {
            data = data.Where(x => x.StateMachine != "Deleted"&&(x.StateMachine=="Active"||x.StateMachine=="Reserved"));
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
    }
}
