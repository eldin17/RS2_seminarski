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
    public class VrstaController : BaseCRUDController<DtoVrsta, SearchVrsta, AddVrsta, UpdateVrsta>
    {
        public VrstaController(IVrstaService service) : base(service)
        {
        }
        [HttpDelete("{id}")]
        public virtual async Task<DtoVrsta> Delete(int id)
        {
            return await (_service as IVrstaService).Delete(id);
        }
    }
}
