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

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class ProdavacController : BaseCRUDController<DtoProdavac, SearchProdavac, AddProdavac, UpdateProdavac>
    {
        private readonly DataContext _context;
        private readonly IMapper _mapper;
        public ProdavacController(IProdavacService service, DataContext context, IMapper mapper) : base(service)
        {
            _context = context;
            _mapper = mapper;
        }
        [HttpDelete("{id}"), Authorize(Roles = "Prodavac")]
        public virtual async Task<DtoProdavac> Delete(int id)
        {
            return await (_service as IProdavacService).Delete(id);
        }
        [HttpGet("getByKorisnickiNalog/{korisnickiId}")]
        public async Task<DtoProdavac> GetByKorisnickiNalogId(int korisnickiId)
        {
            return await (_service as IProdavacService).GetByKorisnickiNalogId(korisnickiId);

        }

        [HttpPost("addSlikaProdavca/{id}"), Authorize(Roles = "Prodavac")]
        public async Task<ActionResult<DtoProdavac>> AddSlikaProdavca(int id, [FromForm] ImgSingleVM obj)
        {
            try
            {
                var prodavac = _context.Prodavci.FirstOrDefault(d => d.ProdavacId == id);

                if (obj.vmSlika != null && prodavac != null)
                {
                    obj.vmSlika.CopyTo(new FileStream(Config.SlikeProdavacaFolder + obj.vmSlika.FileName, FileMode.Create));
                    prodavac.SlikaProdavca = Config.SlikeProdavacaUrl + obj.vmSlika.FileName;
                    await _context.SaveChangesAsync();
                }
                var objDto = _mapper.Map<DtoProdavac>(prodavac);
                return Ok(objDto);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message + ex.InnerException);
            }
        }
    }
}
