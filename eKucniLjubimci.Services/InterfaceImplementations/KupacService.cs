﻿using AutoMapper;
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
        
        public override async Task<DtoKupac> GetById(int id)
        {
            var data = await _context.Set<Kupac>().Include(x => x.Osoba).Include(x => x.Lokacija).Include(x => x.KorisnickiNalog).ThenInclude(x => x.Uloga).FirstOrDefaultAsync(x => x.KupacId == id);

            return _mapper.Map<DtoKupac>(data);
        }

        public override IQueryable<Kupac> AddFilter(IQueryable<Kupac> data, SearchKupac? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (!string.IsNullOrWhiteSpace(search.Grad))
            {
                data = data.Where(x => x.Lokacija.Grad.Contains(search.Grad));
            }
            if (!string.IsNullOrWhiteSpace(search.Drzava))
            {
                data = data.Where(x => x.Lokacija.Drzava.Contains(search.Drzava));
            }
            if (!string.IsNullOrWhiteSpace(search.Ime))
            {
                data = data.Where(x => x.Osoba.Ime.Contains(search.Ime));
            }
            if (!string.IsNullOrWhiteSpace(search.Prezime))
            {
                data = data.Where(x => x.Osoba.Prezime.Contains(search.Prezime));
            }
            if (search.BrojNarudzbiOd != null && search.BrojNarudzbiOd > 0)
            {
                data = data.Where(x => x.BrojNarudzbi >= search.BrojNarudzbiOd);
            }
            if (search.BrojNarudzbiDo != null && search.BrojNarudzbiDo > 0)
            {
                data = data.Where(x => x.BrojNarudzbi <= search.BrojNarudzbiDo);
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
            return base.AddFilter(data, search);

        }

        public async Task<List<DtoKupac>> GetTop3()
        {
            var data = await _context.Set<Kupac>().Include(x => x.Osoba).Include(x => x.Lokacija).Include(x => x.KorisnickiNalog).ThenInclude(x => x.Uloga).OrderByDescending(x=>x.BrojNarudzbi).Take(3).ToListAsync();

            return _mapper.Map<List<DtoKupac>>(data);
        }

        public async Task<DtoKupac> GetByKorisnickiNalogId(int korisnickiId)
        {
            var data = await _context.Set<Kupac>().Include(x => x.Osoba).Include(x => x.Lokacija).Include(x => x.KorisnickiNalog).ThenInclude(x => x.Uloga).FirstOrDefaultAsync(x => x.KorisnickiNalogId == korisnickiId);

            return _mapper.Map<DtoKupac>(data);
        }
    }
}
