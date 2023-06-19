using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KategorijaController : BaseCRUDController<DtoKategorija, SearchKategorija, AddKategorija, UpdateKategorija>
    {
        public KategorijaController(IKategorijaService service) : base(service)
        {
        }
        [HttpDelete("{id}")]
        public virtual async Task<DtoKategorija> Delete(int id)
        {
            return await (_service as IKategorijaService).Delete(id);
        }
    }
}
