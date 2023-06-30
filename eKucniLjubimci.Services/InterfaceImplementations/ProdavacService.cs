using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.InterfaceImplementations
{
    public class ProdavacService : BaseServiceCRUD<DtoProdavac, Prodavac, SearchProdavac, AddProdavac, UpdateProdavac>, IProdavacService
    {
        public ProdavacService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<DtoProdavac> Delete(int id)
        {
            var dbObj = await _context.Set<Prodavac>().FindAsync(id);

            dbObj.isDeleted = true;

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoProdavac>(dbObj);
        }

        public override IQueryable<Prodavac> AddInclude(IQueryable<Prodavac> data, SearchProdavac? search)
        {
            data = data.Include(x => x.Osoba).Include(x=>x.KorisnickiNalog);

            return base.AddInclude(data, search);
        }
        public override async Task<DtoProdavac> GetById(int id)
        {
            var data = await _context.Set<Prodavac>().Include(x => x.Osoba).Include(x => x.KorisnickiNalog).FirstOrDefaultAsync(x => x.ProdavacId == id);

            return _mapper.Map<DtoProdavac>(data);
        }
        public override IQueryable<Prodavac> AddFilter(IQueryable<Prodavac> data, SearchProdavac? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (!string.IsNullOrWhiteSpace(search.PoslovnaJedinica))
            {
                data = data.Where(x => x.PoslovnaJedinica.Contains(search.PoslovnaJedinica));
            }            
            return base.AddFilter(data, search);
        }

        public async Task<DtoProdavac> GetByKorisnickiNalogId(int korisnickiId)
        {
            var data = await _context.Set<Prodavac>().Include(x => x.Osoba).FirstOrDefaultAsync(x => x.KorisnickiNalogId == korisnickiId);

            return _mapper.Map<DtoProdavac>(data);
        }

        public async Task<DtoProdavac> TopAktivnost()
        {
            var data = await _context.Novosti.Where(x=>x.DatumPostavljanja>DateTime.UtcNow.AddMonths(-1)).Include(x => x.Prodavac)
                .ThenInclude(x => x.Osoba)
                .GroupBy(x => x.Prodavac)
                .OrderByDescending(x => x.Count())
                .Select(x => x.Key)
                .FirstOrDefaultAsync();
            var osoba = await _context.Prodavci.Include(x => x.Osoba).FirstOrDefaultAsync(x => x.ProdavacId == data.ProdavacId);
            return _mapper.Map<DtoProdavac>(osoba);
        }
    }
}
