using AutoMapper;
using eKucniLjubimci.Helpers;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Threading;

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KupacController : BaseCRUDController<DtoKupac, SearchKupac, AddKupac, UpdateKupac>
    {
        private readonly DataContext _context;
        private readonly IMapper _mapper;

        public KupacController(IKupacService service, DataContext context, IMapper mapper) : base(service)
        {
            _context = context;
            _mapper = mapper;
        }
        [HttpDelete("{id}"), Authorize(Roles = "Prodavac")]
        public virtual async Task<DtoKupac> Delete(int id)
        {
            return await (_service as IKupacService).Delete(id);
        }

        [HttpPost("addSlikaKupca/{id}"), Authorize(Roles = "Kupac")]
        public async Task<ActionResult<DtoKupac>> AddSlikaKupca(int id, [FromForm] ImgSingleVM obj)
        {
            try
            {
                var kupac = _context.Kupci.FirstOrDefault(d => d.KupacId == id);

                if (obj.vmSlika != null && kupac != null)
                {
                    obj.vmSlika.CopyTo(new FileStream(Config.SlikeKupacaFolder + obj.vmSlika.FileName, FileMode.Create));
                    kupac.SlikaKupca = Config.SlikeKupacaUrl + obj.vmSlika.FileName;
                    await _context.SaveChangesAsync();
                }
                var objDto= _mapper.Map<DtoKupac>(kupac);
                return Ok(objDto);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + ex.InnerException);
            }
        }
    }
}
