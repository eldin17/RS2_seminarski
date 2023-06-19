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
    public class VrstaService : BaseServiceCRUD<DtoVrsta, Vrsta, SearchVrsta, AddVrsta, UpdateVrsta>, IVrstaService
    {
        public VrstaService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<DtoVrsta> Delete(int id)
        {
            var dbObj = await _context.Set<Vrsta>().FindAsync(id);

            dbObj.isDeleted = true;

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoVrsta>(dbObj);
        }

        public override IQueryable<Vrsta> AddFilter(IQueryable<Vrsta> data, SearchVrsta? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (!string.IsNullOrWhiteSpace(search.Naziv))
            {
                data = data.Where(x => x.Naziv.Contains(search.Naziv));
            }
            if (!string.IsNullOrWhiteSpace(search.Rasa))
            {
                data = data.Where(x => x.Rasa.Contains(search.Rasa));
            }
            if (!string.IsNullOrWhiteSpace(search.Boja))
            {
                data = data.Where(x => x.Boja.Contains(search.Boja));
            }            
            if (search.StarostDo != null && search.StarostDo != 0)
            {
                data = data.Where(x => x.Starost <= search.StarostDo);
            }
            if (search.StarostOd != null && search.StarostOd != 0)
            {
                data = data.Where(x => x.Starost >= search.StarostOd);
            }
            if (search.Prostor==true)
            {
                data = data.Where(x => x.Prostor==search.Prostor);
            }

            return base.AddFilter(data, search);
        }
    }
}
