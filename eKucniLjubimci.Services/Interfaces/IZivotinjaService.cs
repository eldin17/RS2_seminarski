using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Interfaces
{
    public interface IZivotinjaService : IBaseServiceCRUD<DtoZivotinja,SearchZivotinja,AddZivotinja,UpdateZivotinja>
    {
        Task<DtoZivotinja> Activate(int id);
        Task<DtoZivotinja> Delete(int id);

        Task<List<string>> AllowedActions(int zivotinjaId);
        Task<DtoZivotinja> Dostupnost(int id, bool dostupnost);

    }
}
