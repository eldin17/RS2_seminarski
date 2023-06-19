using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Interfaces
{
    public interface ILokacijaService:IBaseServiceCRUD<DtoLokacija,SearchLokacija,AddLokacija,UpdateLokacija>
    {
        Task<DtoLokacija> Delete(int id);
    }
}
