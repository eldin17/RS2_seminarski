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
    public interface IProdavacService: IBaseServiceCRUD<DtoProdavac,SearchProdavac,AddProdavac,UpdateProdavac>
    {
        Task<DtoProdavac> Delete(int id);
        Task<DtoProdavac> GetByKorisnickiNalogId(int korisnickiId);
        Task<DtoProdavac> TopAktivnost();
    }
}
