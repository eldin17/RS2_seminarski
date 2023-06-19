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

        public override IQueryable<Prodavac> AddFilter(IQueryable<Prodavac> data, SearchProdavac? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (!string.IsNullOrWhiteSpace(search.PoslovnaJedinica))
            {
                data = data.Where(x => x.PoslovnaJedinica.Contains(search.PoslovnaJedinica));
            }            
            return base.AddFilter(data, search);
        }
    }
}
