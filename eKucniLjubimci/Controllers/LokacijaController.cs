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
    public class LokacijaController : BaseCRUDController<DtoLokacija, SearchLokacija, AddLokacija, UpdateLokacija>
    {
        public LokacijaController(ILokacijaService service) : base(service)
        {
        }
        [HttpDelete("{id}")]
        public virtual async Task<DtoLokacija> Delete(int id)
        {
            return await (_service as ILokacijaService).Delete(id);
        }
    }
}
