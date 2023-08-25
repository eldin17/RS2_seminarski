using AutoMapper;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.InterfaceImplementations
{
    public class BaseServiceCRUD<T, TDb, TSearch, TAdd, TUpdate> : BaseService<T, TDb, TSearch>, IBaseServiceCRUD<T, TSearch, TAdd, TUpdate> where TSearch : BaseSearch where TDb : class
    {
        public BaseServiceCRUD(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public virtual async Task<T> Add(TAdd addRequest)
        {
            var obj = _mapper.Map<TDb>(addRequest);

            _context.Set<TDb>().Add(obj);            

            await _context.SaveChangesAsync();

            SendMail();

            return _mapper.Map<T>(obj);
        }

        public virtual void SendMail()
        {
            return;
        }

        public virtual async Task<T> Update(int id, TUpdate updateRequest)
        {
            var dbObj = await _context.Set<TDb>().FindAsync(id);

            _mapper.Map(updateRequest, dbObj);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(dbObj);
        }        
    }
}
