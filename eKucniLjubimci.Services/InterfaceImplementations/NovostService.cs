using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.InterfaceImplementations
{
    public class NovostService : BaseServiceCRUD<DtoNovost, Novost, SearchNovost, AddNovost, UpdateNovost>, INovostiService
    {
        public NovostService(DataContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override void SendMail()
        {
            string message = $"\nPoruka funkcije Add \nUpravo je dodana novost";

            rmqMail.RabbitMQSend(message);
        }

        public async Task<DtoNovost> Delete(int id)
        {
            var dbObj = await _context.Set<Novost>().FindAsync(id);

            dbObj.isDeleted = true;

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoNovost>(dbObj);
        }

        public override IQueryable<Novost> AddInclude(IQueryable<Novost> data, SearchNovost? search)
        {
            data = data.Include(x => x.Prodavac).ThenInclude(x=>x.Osoba).OrderByDescending(x=>x.DatumPostavljanja);
            return base.AddInclude(data, search);
        }
        public override async Task<DtoNovost> GetById(int id)
        {
            var data = await _context.Set<Novost>().Include(x => x.Prodavac).ThenInclude(x=>x.Osoba).FirstOrDefaultAsync(x => x.NovostId == id);

            return _mapper.Map<DtoNovost>(data);
        }
        public override IQueryable<Novost> AddFilter(IQueryable<Novost> data, SearchNovost? search)
        {
            data = data.Where(x => x.isDeleted == false);
            if (!string.IsNullOrWhiteSpace(search.ProdavacIme))
            {
                data = data.Where(x => x.Prodavac.Osoba.Ime.Contains(search.ProdavacIme));
            }
            if (!string.IsNullOrWhiteSpace(search.ProdavacPrezime))
            {
                data = data.Where(x => x.Prodavac.Osoba.Prezime.Contains(search.ProdavacPrezime));
            }
            if (!string.IsNullOrWhiteSpace(search.Naslov))
            {
                data = data.Where(x => x.Naslov.Contains(search.Naslov));
            }
            if (search.ProdavacId != null)
            {
                data = data.Where(x => x.ProdavacId == search.ProdavacId);
            }
            return base.AddFilter(data, search);
        }
    }
}
