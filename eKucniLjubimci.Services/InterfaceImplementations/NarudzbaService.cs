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
                .Include(x => x.Zivotinje).ThenInclude(y=>y.Slike).Include(x=>x.Zivotinje).ThenInclude(x=>x.Vrsta).ThenInclude(x => x.Rasa).OrderByDescending(x=>x.DatumNarudzbe);
            return base.AddInclude(data, search);
        }
        public override async Task<DtoNarudzba> GetById(int id)
        {
            var data = await _context.Set<Narudzba>().Include(x => x.NarudzbeArtikli).ThenInclude(y => y.Artikal).ThenInclude(z => z.Slike)
                .Include(x => x.Zivotinje).ThenInclude(y => y.Slike).FirstOrDefaultAsync(x => x.NarudzbaId == id);

            return _mapper.Map<DtoNarudzba>(data);
        }

        public override IQueryable<Narudzba> AddFilter(IQueryable<Narudzba> data, SearchNarudzba? search)
        {
            data = data.Where(x => x.StateMachine != "Deleted" && (x.StateMachine=="Active"|| x.StateMachine == "Done" || x.StateMachine == "Draft"));
            if (search.KupacId != null)
            {
                data = data.Where(x => x.KupacId == search.KupacId);
            }
            if (!string.IsNullOrWhiteSpace(search.KupacIme))
            {
                data = data.Where(x => x.Kupac.Osoba.Ime.Contains(search.KupacIme));
            }
            if (!string.IsNullOrWhiteSpace(search.KupacPrezime))
            {
                data = data.Where(x => x.Kupac.Osoba.Prezime.Contains(search.KupacPrezime));
            }
            if (search.TotalDo != null && search.TotalDo > 0)
            {
                data = data.Where(x => x.TotalFinal <= search.TotalDo);
            }
            if (search.TotalOd != null && search.TotalOd > 0)
            {
                data = data.Where(x => x.TotalFinal >= search.TotalOd);
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

        public async Task<DtoNarudzba> DeActivate(int narudzbaId)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.DeActivate(narudzbaId);
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

        public async Task<List<string>> AllowedActions(int narudzbaId)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.AllowedActionsInState();
        }

        public async Task<DtoNarudzba> GetTopLastMonth()
        {
            Narudzba data = await _context.Narudzbe.Where(x => x.StateMachine == "Done").Include(x => x.NarudzbeArtikli).ThenInclude(y => y.Artikal).ThenInclude(z => z.Slike)
                            .Include(x => x.Zivotinje).ThenInclude(y => y.Slike).Include(x => x.Zivotinje).ThenInclude(x => x.Vrsta).Where(x=>x.DatumNarudzbe>DateTime.UtcNow.AddMonths(-1)).
                            OrderByDescending(x => x.TotalFinal).FirstOrDefaultAsync();
            return _mapper.Map<DtoNarudzba>(data);
        }

        public async Task<DtoNarudzba> GetTopAllTime()
        {
            Narudzba data = await _context.Narudzbe.Where(x=>x.StateMachine=="Done").Include(x => x.NarudzbeArtikli).ThenInclude(y => y.Artikal).ThenInclude(z => z.Slike)
                            .Include(x => x.Zivotinje).ThenInclude(y => y.Slike).Include(x => x.Zivotinje).ThenInclude(x => x.Vrsta).
                            OrderByDescending(x => x.TotalFinal).FirstOrDefaultAsync();
            return _mapper.Map<DtoNarudzba>(data);
        }

        public async Task<decimal> GetTotalLastMonth()
        {
            decimal total = 0;
            var data = await _context.Narudzbe.Where(x => x.StateMachine == "Done").Where(x => x.DatumNarudzbe > DateTime.UtcNow.AddMonths(-1)).ToListAsync();
            foreach (var item in data)
            {
                total += item.TotalFinal;
            }
            return total;
        }

        public async Task<decimal> GetTotalAllTime()
        {
            decimal total = 0;
            var data = await _context.Narudzbe.Where(x => x.StateMachine == "Done").ToListAsync();
            foreach (var item in data)
            {
                total += item.TotalFinal;
            }
            return total;
        }

        public async Task<List<DtoNarudzba>> GetAllLastMonth()
        {
            var data = await _context.Narudzbe.Where(x => x.DatumNarudzbe > DateTime.UtcNow.AddMonths(-1)).OrderByDescending(x=>x.DatumNarudzbe).ToListAsync();
            data.Reverse();
            return _mapper.Map<List<DtoNarudzba>>(data);
        }

        public async Task<List<DtoNarudzba>> GetByKupac(int kupac)
        {
            var data = await _context.Set<Narudzba>()
                .Include(x => x.NarudzbeArtikli).ThenInclude(y => y.Artikal).ThenInclude(z => z.Slike)
                .Include(x => x.NarudzbeArtikli).ThenInclude(y => y.Artikal).ThenInclude(z => z.Kategorija)
                .Include(x => x.Zivotinje).ThenInclude(y => y.Slike)
                .Include(x => x.Zivotinje).ThenInclude(y => y.Vrsta)
                .Where(x=>x.StateMachine=="Done")
                .Where(x => x.KupacId == kupac)
                .OrderByDescending(x=>x.DatumNarudzbe)
                .ToListAsync();

            return _mapper.Map<List<DtoNarudzba>>(data);
        }

        public async Task<DtoNarudzba> Payment(int narudzbaId)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.Payment(narudzbaId);
        }

        public async Task<DtoNarudzba> StripeReference(int narudzbaId, AddReference reference)
        {
            var narudzba = await _context.Narudzbe.FindAsync(narudzbaId);
            var state = _baseNarudzbaState.GetState(narudzba.StateMachine);
            return await state.StripeReference(narudzbaId, reference);
        }
    }
}
