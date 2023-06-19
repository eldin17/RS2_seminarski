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
    public class ZivotinjaController : BaseCRUDController<DtoZivotinja, SearchZivotinja, AddZivotinja, UpdateZivotinja>
    {
        private readonly DataContext _context;

        public ZivotinjaController(IZivotinjaService service, DataContext context) : base(service)
        {
            _context = context;
        }

        [HttpPut("{id}/activate")]
        public virtual async Task<DtoZivotinja> Activate(int id)
        {
            return await (_service as IZivotinjaService).Activate(id);
        }

        [HttpPut("{id}/delete")]
        public virtual async Task<DtoZivotinja> Delete(int id)
        {
            return await (_service as IZivotinjaService).Delete(id);
        }

        [HttpPost("addSlikeZivotinja/{id}")]
        public async Task<IActionResult> AddSlikeZivotinja(int id, [FromForm] ImgMultipleVM obj)
        {
            var zivotinja = await _context.Zivotinje.FirstOrDefaultAsync(x => x.ZivotinjaId == id);
            if (obj == null && (zivotinja.StateMachine!="Draft" || zivotinja.StateMachine != "Active"))
            {
                return Content("Pogresan unos!");
            }

            var stareSlike = _context.Slike.Where(x => x.ZivotinjaId == id).ToList();
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
                var path = Path.Combine(Config.SlikeZivotinjaFolder, item.FileName);

                using (FileStream stream = new FileStream(path, FileMode.Create))
                {
                    await item.CopyToAsync(stream);
                    stream.Close();
                }

                var nova = new Slika
                {
                    ZivotinjaId = id,
                    Naziv = item.FileName,
                    Putanja = Config.SlikeZivotinjaUrl + item.FileName
                };

                _context.Add(nova);
                await _context.SaveChangesAsync();
            }

            return Ok(obj);
        }


        
    }
}
