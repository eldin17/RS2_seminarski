using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Interfaces
{
    public interface INarudzbaService:IBaseServiceCRUD<DtoNarudzba,SearchNarudzba,AddNarudzba,UpdateNarudzba>
    {
        Task<DtoNarudzba> AddArtikal(int narudzbaId, int artikalId, int kolicina);
        Task<DtoNarudzba> RemoveArtikal(int narudzbaId, int artikalId);

        Task<DtoNarudzba> AddZivotinja(int narudzbaId, int zivotinjaId);
        Task<DtoNarudzba> RemoveZivotinja(int narudzbaId, int zivotinjaId);

        Task<DtoNarudzba> Activate(int narudzbaId);
        Task<DtoNarudzba> Delete(int narudzbaId);
        Task<DtoNarudzba> Cancel(int narudzbaId);
        Task<StripeCustomer> StripeCustomer(AddStripeCustomer customer, int narudzbaId, CancellationToken ct);
        Task<StripePayment> StripePayment(AddStripePayment payment, int narudzbaId, CancellationToken ct);
        Task<DtoNarudzba> Payment(int narudzbaId);

        Task<List<string>> AllowedActions(int narudzbaId);
        Task<DtoNarudzba> GetTopLastMonth();
        Task<DtoNarudzba> GetTopAllTime();
        Task<decimal> GetTotalLastMonth();
        Task<decimal> GetTotalAllTime();
        Task<List<DtoNarudzba>> GetAllLastMonth();
        Task<List<DtoNarudzba>> GetByKupac(int kupac);


    }
}
