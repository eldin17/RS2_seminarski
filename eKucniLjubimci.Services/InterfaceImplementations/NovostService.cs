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
    public class NovostService : BaseServiceCRUD<DtoNovost, Novost, SearchNovost, AddNovost, UpdateNovost>, INovostiService
    {
        public NovostService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<DtoNovost> Delete(int id)
        {
            var dbObj = await _context.Set<Novost>().FindAsync(id);

            dbObj.isDeleted = true;

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoNovost>(dbObj);
        }

        public override IQueryable<Novost> AddInclude(IQueryable<Novost> data, SearchNovost? search)
        {
            data = data.Include(x => x.Prodavac);
            return base.AddInclude(data, search);
        }

        public override IQueryable<Novost> AddFilter(IQueryable<Novost> data, SearchNovost? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (!string.IsNullOrWhiteSpace(search.Naslov))
            {
                data = data.Where(x => x.Naslov.Contains(search.Naslov));
            }
            if (search.ProdavacId != null)
            {
                data = data.Where(x => x.ProdavacId == search.ProdavacId);
            }
            return base.AddFilter(data, search);
        }
    }
}
