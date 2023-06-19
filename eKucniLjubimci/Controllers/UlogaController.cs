using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UlogaController : BaseController<DtoUloga, SearchUloga>
    {
        public UlogaController(IUlogaService service) : base(service)
        {
        }
    }
}
