using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Interfaces
{
    public interface IBaseServiceCRUD<T, TSearch, TAdd, TUpdate> : IBaseService<T, TSearch> where TSearch : class
    {
        Task<T> Add(TAdd addRequest);
        Task<T> Update(int id, TUpdate updateRequest);
    }
}
