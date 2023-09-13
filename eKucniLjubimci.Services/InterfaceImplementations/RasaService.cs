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
    public class RasaService : BaseServiceCRUD<DtoRasa, Rasa, SearchRasa,AddRasa,UpdateRasa>, IRasaService
    {
        public RasaService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Rasa> AddFilter(IQueryable<Rasa> data, SearchRasa? search)
        {
            if (!string.IsNullOrWhiteSpace(search.Naziv))
            {
                data = data.Where(x => x.Naziv.Contains(search.Naziv));
            }
            return base.AddFilter(data, search);
        }
        public async Task<DtoRasa> Delete(int id)
        {
            var dbObj = await _context.Set<Rasa>().FindAsync(id);

            dbObj.isDeleted = true;

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoRasa>(dbObj);
        }
    }
}
