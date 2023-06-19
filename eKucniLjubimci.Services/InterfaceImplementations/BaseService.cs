using AutoMapper;
using Azure;
using eKucniLjubimci.Model;
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
    public class BaseService<T, TDb, TSearch> : IBaseService<T, TSearch> where TSearch : BaseSearch where TDb : class
    {
        protected DataContext _context;
        protected IMapper _mapper;
        public BaseService(DataContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public virtual async Task<Pagination<T>> GetAll(TSearch? search = null)
        {
            var data = _context.Set<TDb>().AsQueryable();

            data = AddFilter(data, search);
            data = AddInclude(data, search);

            var totalItems = await data.CountAsync();

            if (search?.PageNumber.HasValue == true && search?.ItemsPerPage.HasValue == true)
            {
                data = data
                    .Skip((search.PageNumber.Value - 1) * search.ItemsPerPage.Value)
                    .Take(search.ItemsPerPage.Value);                
            }
                       
            var tolist = await data.ToListAsync();
            var list = _mapper.Map<List<T>>(tolist);

            return new Pagination<T>(list,totalItems);
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> data, TSearch? search)
        {
            
            return data;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> data, TSearch? search)
        {
            return data;
        }

        public virtual async Task<T> GetById(int id)
        {
            var data = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(data);
        }

        
    }
}
