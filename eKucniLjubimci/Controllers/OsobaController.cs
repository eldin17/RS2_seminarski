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
    public class OsobaController : BaseCRUDController<DtoOsoba, SearchOsoba, AddOsoba, UpdateOsoba>
    {
        public OsobaController(IOsobaService service) : base(service)
        {
        }
        [HttpDelete("{id}")]
        public virtual async Task<DtoOsoba> Delete(int id)
        {
            return await (_service as IOsobaService).Delete(id);
        }
    }
}
