using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RasaController : BaseCRUDController<DtoRasa, SearchRasa,AddRasa,UpdateRasa>
    {
        public RasaController(IRasaService service) : base(service)
        {
        }
        [HttpDelete("{id}"), Authorize(Roles = "Prodavac")]
        public virtual async Task<DtoRasa> Delete(int id)
        {
            return await (_service as IRasaService).Delete(id);
        }
    }
}
