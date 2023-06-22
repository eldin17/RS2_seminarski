using AutoMapper;
using EasyNetQ;
using eKucniLjubimci.Helpers;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.ArtikalStateMachine.RabbitMQType;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using eKucniLjubimci.Services.ZivotinjaStateMachine.RabbitMQType;
using Microsoft.AspNetCore.Authorization;
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
        private readonly IMapper _mapper;

        public ZivotinjaController(IZivotinjaService service, DataContext context, IMapper mapper) : base(service)
        {
            _context = context;
            _mapper = mapper;
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IZivotinjaService).AllowedActions(id);
        }

        [HttpPut("{id}/activate"), Authorize(Roles = "Prodavac")]
        public virtual async Task<DtoZivotinja> Activate(int id)
        {
            return await (_service as IZivotinjaService).Activate(id);
        }

        [HttpPut("{id}/delete"), Authorize(Roles = "Prodavac")]
        public virtual async Task<DtoZivotinja> Delete(int id)
        {
            return await (_service as IZivotinjaService).Delete(id);
        }

        [HttpPut("{id}/dostupnost"), Authorize(Roles = "Prodavac")]
        public virtual async Task<DtoZivotinja> Dostupnost(int id, bool dostupnost)
        {
            return await (_service as IZivotinjaService).Dostupnost(id, dostupnost);
        }
        

        [HttpPost("addSlikeZivotinja/{id}"), Authorize(Roles = "Prodavac")]
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



            var mappedEntity = _mapper.Map<rmqZivotinja>(zivotinja);
            mappedEntity.Funkcija = "AddSlike";

            using var bus = RabbitHutch.CreateBus("host=ekucniljubimci-rmq");
            //using var bus = RabbitHutch.CreateBus("host=localhost");

            bus.PubSub.Publish(mappedEntity);



            return Ok(obj);
        }


        
    }
}
