using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.ArtikalStateMachine;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using eKucniLjubimci.Services.ZivotinjaStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.InterfaceImplementations
{
    public class ArtikalService : BaseServiceCRUD<DtoArtikal, Artikal, SearchArtikal, AddArtikal, UpdateArtikal>, IArtikalService
    {
        BaseArtikalState _baseArtikalState;

        public ArtikalService(DataContext context, IMapper mapper, BaseArtikalState baseArtikalState) : base(context, mapper)
        {
            _baseArtikalState= baseArtikalState;
        }

        public override IQueryable<Artikal> AddInclude(IQueryable<Artikal> data, SearchArtikal? search)
        {
            data = data.Include(x => x.Kategorija).Include(x => x.Slike);
            return base.AddInclude(data, search);
        }
        public override async Task<DtoArtikal> GetById(int id)
        {
            var data = await _context.Set<Artikal>().Include(x => x.Kategorija).Include(x => x.Slike).FirstOrDefaultAsync(x => x.ArtikalId == id);

            return _mapper.Map<DtoArtikal>(data);
        }
        public override IQueryable<Artikal> AddFilter(IQueryable<Artikal> data, SearchArtikal? search)
        {
            data = data.Where(x => x.StateMachine != "Deleted").Where(x => x.Slike.Count > 0);
            if (!string.IsNullOrWhiteSpace(search.Naziv))
            {
                data = data.Where(x => x.Naziv.Contains(search.Naziv));
            }
            if (search.CijenaDo!=null && search.CijenaDo>0)
            {
                data = data.Where(x => x.Cijena<=search.CijenaDo);
            }
            if (search.CijenaOd != null && search.CijenaOd > 0)
            {
                data = data.Where(x => x.Cijena >= search.CijenaOd);
            }

            return base.AddFilter(data, search);
        }

        public override async Task<DtoArtikal> Add(AddArtikal addRequest)
        {
            var state = _baseArtikalState.GetState(addRequest.StateMachine);
            return await state.Add(addRequest);
        }

        public override async Task<DtoArtikal> Update(int id, UpdateArtikal updateRequest)
        {
            var artikal = await _context.Artikli.FindAsync(id);
            var state = _baseArtikalState.GetState(artikal.StateMachine);
            return await state.Update(id, updateRequest);
        }

        public async Task<DtoArtikal> Activate(int id)
        {
            var artikal = await _context.Artikli.FindAsync(id);
            var state = _baseArtikalState.GetState(artikal.StateMachine);
            return await state.Activate(id);
        }

        public async Task<DtoArtikal> Delete(int id)
        {
            var artikal = await _context.Artikli.FindAsync(id);
            var state = _baseArtikalState.GetState(artikal.StateMachine);
            return await state.Delete(id);
        }

        public async Task<List<string>> AllowedActions(int zivotinjaId)
        {
            var artikal = await _context.Artikli.FindAsync(zivotinjaId);
            var state = _baseArtikalState.GetState(artikal.StateMachine);
            return await state.AllowedActionsInState();
        }
        public async Task<DtoArtikal> Dostupnost(int id, bool dostupnost)
        {
            var artikal = await _context.Artikli.FindAsync(id);
            var state = _baseArtikalState.GetState(artikal.StateMachine);
            return await state.Dostupnost(id,dostupnost);
        }

    }
}
