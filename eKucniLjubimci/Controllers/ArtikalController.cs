using eKucniLjubimci.Helpers;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ArtikalController : BaseCRUDController<DtoArtikal, SearchArtikal, AddArtikal, UpdateArtikal>
    {
        private readonly DataContext _context;

        public ArtikalController(IArtikalService service, DataContext context) : base(service)
        {
            _context = context;
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IArtikalService).AllowedActions(id);
        }

        [HttpPut("{id}/activate")]
        public virtual async Task<DtoArtikal> Activate(int id)
        {
            return await (_service as IArtikalService).Activate(id);
        }

        [HttpPut("{id}/delete")]
        public virtual async Task<DtoArtikal> Delete(int id)
        {
            return await (_service as IArtikalService).Delete(id);
        }

        [HttpPost("addSlikeArtikla/{id}")]
        public async Task<IActionResult> AddSlikeArtikla(int id, [FromForm] ImgMultipleVM obj)
        {
            var artikal = await _context.Artikli.FirstOrDefaultAsync(x => x.ArtikalId == id);

            if (obj == null && (artikal.StateMachine != "Draft" || artikal.StateMachine != "Active"))
            {
                return Content("Pogresan unos!");
            }

            var stareSlike =await _context.Slike.Where(x => x.ArtikalId == id).ToListAsync();
            if (stareSlike.Count > 0)
            {
                _context.Slike.RemoveRange(stareSlike);
                _context.SaveChanges();
                stareSlike = null;
            }

            foreach (var item in obj.vmSlike)
            {

                if (item.FileName == null || item.FileName.Length == 0)
                {
                    return Content("Pogresan odabir!");
                }
                var path = Path.Combine(Config.SlikeArtikalaFolder, item.FileName);

                using (FileStream stream = new FileStream(path, FileMode.Create))
                {
                    await item.CopyToAsync(stream);
                    stream.Close();
                }

                var nova = new Slika
                {
                    ArtikalId = id,
                    Naziv = item.FileName,
                    Putanja = Config.SlikeArtikalaUrl + item.FileName
                };                               

                _context.Add(nova);
                await _context.SaveChangesAsync();
            }

            return Ok(obj);
        }
    }
}
