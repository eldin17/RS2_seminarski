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
    public interface IArtikalService : IBaseServiceCRUD<DtoArtikal,SearchArtikal,AddArtikal,UpdateArtikal>
    {
        Task<DtoArtikal> Activate(int id);
        Task<DtoArtikal> Delete(int id);

        Task<List<string>> AllowedActions(int zivotinjaId);
        Task<DtoArtikal> Dostupnost(int id, bool dostupnost);
    }
}
