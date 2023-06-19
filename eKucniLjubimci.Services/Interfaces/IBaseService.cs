using eKucniLjubimci.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Interfaces
{
    public interface IBaseService<T,TSearch> where TSearch : class
    {
        Task<Pagination<T>> GetAll(TSearch search = null);
        Task<T> GetById(int id);
    }
}
