using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using eKucniLjubimci.Services.NarudzbaStateMachine;
using eKucniLjubimci.Services.Stripe;
using Microsoft.EntityFrameworkCore;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.InterfaceImplementations
{
    public class NarudzbaService : BaseServiceCRUD<DtoNarudzba, Narudzba, SearchNarudzba, AddNarudzba, UpdateNarudzba>, INarudzbaService
    {
        BaseNarudzbaState _baseNarudzbaState;
        public NarudzbaService(DataContext context, IMapper mapper, BaseNarudzbaState baseNarudzbaState) : base(context, mapper)
        {
            _baseNarudzbaState= baseNarudzbaState;
        }
        public override IQueryable<Narudzba> AddInclude(IQueryable<Narudzba> data, SearchNarudzba? search)
        {
            data = data.Include(x => x.NarudzbeArtikli).ThenInclude(y=>y.Artikal).ThenInclude(z => z.Slike)
                .Include(x => x.Zivotinje).ThenInclude(y=>y.Slike);
            return base.AddInclude(data, search);
        }
        
        public override IQueryable<Narudzba> AddFilter(IQueryable<Narudzba> data, SearchNarudzba? search)
        {
            data = data.Where(x => x.StateMachine != "Deleted" && (x.StateMachine=="Active"|| x.StateMachine == "Done" || x.StateMachine == "Draft"));
            if (search.KupacId != null)
            {
                data = data.Where(x => x.KupacId == search.KupacId);
            }
            return base.AddFilter(data, search);
        }

        public async Task<DtoNarudzba> AddArtikal(int narudzbaId, int artikalId,int kolicina)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.AddArtikal(narudzbaId, artikalId, kolicina);
        }

        public async Task<DtoNarudzba> RemoveArtikal(int narudzbaId, int artikalId)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.RemoveArtikal(narudzbaId, artikalId);
        }

        public override async Task<DtoNarudzba> Add(AddNarudzba addRequest)
        {            
            var state = _baseNarudzbaState.GetState(addRequest.StateMachine);
            return await state.Add(addRequest);
        }

        public override async Task<DtoNarudzba> Update(int id, UpdateNarudzba updateRequest)
        {
            var narudzba = await _context.Narudzbe.FindAsync(id);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.Update(id, updateRequest);
        }

        public async Task<DtoNarudzba> AddZivotinja(int narudzbaId, int zivotinjaId)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.AddZivotinja(narudzbaId, zivotinjaId);
        }

        public async Task<DtoNarudzba> RemoveZivotinja(int narudzbaId, int zivotinjaId)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.RemoveZivotinja(narudzbaId, zivotinjaId);
        }

        public async Task<DtoNarudzba> Activate(int narudzbaId)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.Activate(narudzbaId);
        }

        public async Task<DtoNarudzba> Delete(int narudzbaId)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.Delete(narudzbaId);
        }

        public async Task<DtoNarudzba> Cancel(int narudzbaId)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.Cancel(narudzbaId);
        }

        public async Task<StripeCustomer> StripeCustomer(AddStripeCustomer customer, int narudzbaId, CancellationToken ct)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.StripeCustomer(customer, narudzbaId, ct);
        }

        public async Task<StripePayment> StripePayment(AddStripePayment payment, int narudzbaId, CancellationToken ct)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.StripePayment(payment, narudzbaId, ct);
        }
    }
}
