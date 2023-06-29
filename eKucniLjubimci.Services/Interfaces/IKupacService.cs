using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.InterfaceImplementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Interfaces
{
    public interface IKupacService : IBaseServiceCRUD<DtoKupac,SearchKupac,AddKupac,UpdateKupac>
    {
        Task<DtoKupac> Delete(int id);
    }
}
