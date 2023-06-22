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
    public class NovostController : BaseCRUDController<DtoNovost, SearchNovost, AddNovost, UpdateNovost>
    {
        public NovostController(INovostiService service) : base(service)
        {
        }
        [HttpDelete("{id}"), Authorize(Roles = "Prodavac")]
        public virtual async Task<DtoNovost> Delete(int id)
        {
            return await (_service as INovostiService).Delete(id);
        }
    }
}
