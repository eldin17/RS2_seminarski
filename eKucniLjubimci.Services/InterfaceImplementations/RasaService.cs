using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
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
    public class RasaService : BaseService<DtoRasa, Rasa, SearchRasa>, IRasaService
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
    }
}
