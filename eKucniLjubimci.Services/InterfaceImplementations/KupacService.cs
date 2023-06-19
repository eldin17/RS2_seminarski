using AutoMapper;
using eKucniLjubimci.Model;
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
    public class KupacService : BaseServiceCRUD<DtoKupac, Kupac, SearchKupac, AddKupac, UpdateKupac>, IKupacService
    {
        public KupacService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<DtoKupac> Delete(int id)
        {
            var dbObj = await _context.Set<Kupac>().FindAsync(id);

            dbObj.isDeleted = true;

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoKupac>(dbObj);
        }

        public override IQueryable<Kupac> AddInclude(IQueryable<Kupac> data, SearchKupac? search)
        {
            data=data.Include(x=>x.Osoba).Include(x=>x.Lokacija).Include(x=>x.KorisnickiNalog).ThenInclude(x=>x.Uloga);
            return base.AddInclude(data, search);
        }

        public override IQueryable<Kupac> AddFilter(IQueryable<Kupac> data, SearchKupac? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (search.BrojNarudzbi != null && search.BrojNarudzbi > 0)
            {
                data = data.Where(x => x.BrojNarudzbi <= search.BrojNarudzbi);
            }
            if (search.Kuca==true)
            {
                data = data.Where(x => x.Kuca==search.Kuca);
            }
            if (search.Dvoriste == true)
            {
                data = data.Where(x => x.Dvoriste == search.Dvoriste);
            }
            if (search.Stan == true)
            {
                data = data.Where(x => x.Stan == search.Stan);
            }
            if (!string.IsNullOrWhiteSpace(search.ImePrezime))
            {
                data = data.Where(x => x.Osoba.Ime.Contains(search.ImePrezime) || 
                x.Osoba.Prezime.Contains(search.ImePrezime));
            }
            return base.AddFilter(data, search);

        }
    }
}
