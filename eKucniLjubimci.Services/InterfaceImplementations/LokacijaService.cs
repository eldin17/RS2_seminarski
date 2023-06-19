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
    public class LokacijaService : BaseServiceCRUD<DtoLokacija, Lokacija, SearchLokacija, AddLokacija, UpdateLokacija>, ILokacijaService
    {
        public LokacijaService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public async Task<DtoLokacija> Delete(int id)
        {
            var dbObj = await _context.Set<Lokacija>().FindAsync(id);

            dbObj.isDeleted = true;

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoLokacija>(dbObj);
        }

        public override IQueryable<Lokacija> AddFilter(IQueryable<Lokacija> data, SearchLokacija? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (!string.IsNullOrWhiteSpace(search.Drzava))
            {
                data = data.Where(x => x.Drzava.Contains(search.Drzava));
            }
            if (!string.IsNullOrWhiteSpace(search.Grad))
            {
                data = data.Where(x => x.Grad.Contains(search.Grad));
            }
            if (!string.IsNullOrWhiteSpace(search.Ulica))
            {
                data = data.Where(x => x.Ulica.Contains(search.Ulica));
            }
            return base.AddFilter(data, search);
        }
    }
}
