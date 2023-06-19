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
    public class KategorijaService : BaseServiceCRUD<DtoKategorija, Kategorija, SearchKategorija, AddKategorija, UpdateKategorija>, IKategorijaService
    {
        public KategorijaService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<DtoKategorija> Delete(int id)
        {
            var dbObj = await _context.Set<Kategorija>().FindAsync(id);

            dbObj.isDeleted = true;

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoKategorija>(dbObj);
        }

        public override IQueryable<Kategorija> AddFilter(IQueryable<Kategorija> data, SearchKategorija? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (!string.IsNullOrWhiteSpace(search.Naziv))
            {
                data = data.Where(x => x.Naziv.Contains(search.Naziv));
            }
            return base.AddFilter(data, search);
        }
    }
}
