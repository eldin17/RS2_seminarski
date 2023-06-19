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
    public class UlogaService : BaseService<DtoUloga, Uloga, SearchUloga>, IUlogaService
    {
        public UlogaService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Uloga> AddFilter(IQueryable<Uloga> data, SearchUloga? search)
        {
            if (!string.IsNullOrWhiteSpace(search.Naziv))
            {
                data = data.Where(x => x.Naziv.Contains(search.Naziv));
            }
            return base.AddFilter(data, search);
        }
    }
}
