using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.InterfaceImplementations
{
    public class OsobaService : BaseServiceCRUD<DtoOsoba, Osoba, SearchOsoba, AddOsoba, UpdateOsoba>, IOsobaService
    {
        public OsobaService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }
        
        public async Task<DtoOsoba> Delete(int id)
        {
            var dbObj = await _context.Set<Osoba>().FindAsync(id);

            dbObj.isDeleted = true;

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoOsoba>(dbObj);
        }


        public override IQueryable<Osoba> AddFilter(IQueryable<Osoba> data, SearchOsoba? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (!string.IsNullOrWhiteSpace(search.Ime))
            {
                data = data.Where(x => x.Ime.Contains(search.Ime));
            }
            if (!string.IsNullOrWhiteSpace(search.Prezime))
            {
                data = data.Where(x => x.Prezime.Contains(search.Prezime));
            }
            return base.AddFilter(data, search);
        }
    }
}
