using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using eKucniLjubimci.Services.Stripe;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NarudzbaController : BaseCRUDController<DtoNarudzba, SearchNarudzba, AddNarudzba, UpdateNarudzba>
    {
        public NarudzbaController(INarudzbaService service) : base(service)
        {
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as INarudzbaService).AllowedActions(id);
        }

        [HttpPost("{narudzbaId}/AddArtikal/{artikalId}")]
        public virtual async Task<DtoNarudzba> AddArtikal(int narudzbaId, int artikalId, int kolicina)
        {
            return await (_service as INarudzbaService).AddArtikal(narudzbaId, artikalId,kolicina);
        }

        [HttpPut("{narudzbaId}/RemoveArtikal/{artikalId}")]
        public virtual async Task<DtoNarudzba> RemoveArtikal(int narudzbaId, int artikalId)
        {
            return await (_service as INarudzbaService).RemoveArtikal(narudzbaId, artikalId);
        }

        [HttpPost("{narudzbaId}/AddZivotinja/{zivotinjaId}")]
        public virtual async Task<DtoNarudzba> AddZivotinja(int narudzbaId, int zivotinjaId)
        {
            return await (_service as INarudzbaService).AddZivotinja(narudzbaId, zivotinjaId);
        }

        [HttpPut("{narudzbaId}/RemoveZivotinja/{zivotinjaId}")]
        public virtual async Task<DtoNarudzba> RemoveZivotinja(int narudzbaId, int zivotinjaId)
        {
            return await (_service as INarudzbaService).RemoveZivotinja(narudzbaId, zivotinjaId);
        }

        [HttpPut("{narudzbaId}/activate")]
        public virtual async Task<DtoNarudzba> Activate(int narudzbaId)
        {
            return await (_service as INarudzbaService).Activate(narudzbaId);
        }

        [HttpPut("{narudzbaId}/delete")]
        public virtual async Task<DtoNarudzba> Delete(int narudzbaId)
        {
            return await (_service as INarudzbaService).Delete(narudzbaId);
        }

        [HttpPut("{narudzbaId}/cancel")]
        public virtual async Task<DtoNarudzba> Cancel(int narudzbaId)
        {
            return await (_service as INarudzbaService).Cancel(narudzbaId);
        }

        [HttpPost("AddCustomerStripe/{id}"), Authorize(Roles = "Kupac")]
        public async Task<StripeCustomer> AddStripeCustomer([FromBody] AddStripeCustomer customer, int id, CancellationToken ct)
        {
            return await (_service as INarudzbaService).StripeCustomer(customer,id, ct);
        }

        [HttpPost("AddPaymentStripe/{id}"), Authorize(Roles = "Kupac")]
        public async Task<StripePayment> AddStripePayment([FromBody] AddStripePayment payment, int id, CancellationToken ct)
        {
            return await (_service as INarudzbaService).StripePayment(payment, id, ct);
        }
        [HttpPost("AddPaymentFlutterStripe/{id}"), Authorize(Roles = "Kupac")]
        public async Task<DtoNarudzba> AddPaymentFlutterStripe(int id)
        {
            return await (_service as INarudzbaService).Payment(id);
        }

        [HttpGet("topLastMonth"), Authorize(Roles = "Prodavac")]
        public async Task<DtoNarudzba> GetTopLastMonth()
        {
            return await (_service as INarudzbaService).GetTopLastMonth();
        }
        [HttpGet("topAllTime"), Authorize(Roles = "Prodavac")]
        public async Task<DtoNarudzba> GetTopAllTime()
        {
            return await (_service as INarudzbaService).GetTopAllTime();

        }
        [HttpGet("totalLastMonth"), Authorize(Roles = "Prodavac")]
        public async Task<decimal> GetTotalLastMonth()
        {
            return await (_service as INarudzbaService).GetTotalLastMonth();
        }
        [HttpGet("totalAllTime"), Authorize(Roles = "Prodavac")]
        public async Task<decimal> GetTotalAllTime()
        {
            return await (_service as INarudzbaService).GetTotalAllTime();
        }
        [HttpGet("allLastMonth"), Authorize(Roles = "Prodavac")]
        public async Task<List<DtoNarudzba>> GetAllLastMonth()
        {
            return await (_service as INarudzbaService).GetAllLastMonth();
        }
        [HttpGet("getByKupac/{id}")]
        public async Task<List<DtoNarudzba>> GetByKupac(int id)
        {
            return await (_service as INarudzbaService).GetByKupac(id);
        }
    }
}
