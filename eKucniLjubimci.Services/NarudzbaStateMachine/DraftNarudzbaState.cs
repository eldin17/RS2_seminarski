using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.NarudzbaStateMachine
{
    public class DraftNarudzbaState : BaseNarudzbaState
    {
        public DraftNarudzbaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<List<string>> AllowedActionsInState()
        {
            var actions = await base.AllowedActionsInState();
            actions.Add("AddArtikal");
            actions.Add("RemoveArtikal");
            actions.Add("AddZivotinja");
            actions.Add("RemoveZivotinja");
            actions.Add("Update");
            actions.Add("Delete");
            return actions;
        }

        public override async Task<DtoNarudzba> AddArtikal(int narudzbaId, int artikalId,int kolicina)
        {
            var narudzba = await _context.Narudzbe.FirstOrDefaultAsync(x => x.NarudzbaId == narudzbaId);
            var artikal = await _context.Artikli.FirstOrDefaultAsync(x => x.ArtikalId == artikalId);
            
            if (narudzba != null && artikal != null && artikal.StateMachine=="Active")
            {
                for (int i = 0; i < kolicina; i++)
                {
                    narudzba.TotalFinal +=  artikal.Cijena;

                    NarudzbaArtikal novi = new NarudzbaArtikal
                    {
                        NarudzbaId = narudzba.NarudzbaId,
                        ArtikalId = artikal.ArtikalId,
                    };
                    _context.NarudzbeArtikli.Add(novi);
                    await _context.SaveChangesAsync();
                }

                var obj = _mapper.Map<DtoNarudzba>(narudzba);
                return obj;
            }
            return null;
        }

        public override async Task<DtoNarudzba> RemoveArtikal(int narudzbaId, int artikalId)
        {
            var narudzba = await _context.Narudzbe.Include(x=>x.NarudzbeArtikli).ThenInclude(x=>x.Artikal).FirstOrDefaultAsync(x => x.NarudzbaId == narudzbaId);
            var narudzbaArtikal = narudzba.NarudzbeArtikli.FirstOrDefault(x=>x.ArtikalId == artikalId);
            var artikal = await _context.Artikli.FirstOrDefaultAsync(x => x.ArtikalId == artikalId);

            if (narudzbaArtikal != null)
            {                
                narudzba.TotalFinal -= artikal.Cijena;

                _context.NarudzbeArtikli.Remove(narudzbaArtikal);

                await _context.SaveChangesAsync(); 
                return _mapper.Map<DtoNarudzba>(narudzba);
            }
            return null;
        }

        public override async Task<DtoNarudzba> AddZivotinja(int narudzbaId, int zivotinjaId)
        {
            var narudzba = await _context.Narudzbe.FirstOrDefaultAsync(x => x.NarudzbaId == narudzbaId);
            var zivotinja = await _context.Zivotinje.FirstOrDefaultAsync(x => x.ZivotinjaId == zivotinjaId);

            if (narudzba != null && zivotinja != null && zivotinja.StateMachine=="Active")
            {
                narudzba.TotalFinal += zivotinja.Cijena;

                zivotinja.NarudzbaId = narudzbaId;
                zivotinja.StateMachine = "Reserved";
                await _context.SaveChangesAsync();
                return _mapper.Map<DtoNarudzba>(narudzba);
            }
            return null;
        }

        public override async Task<DtoNarudzba> RemoveZivotinja(int narudzbaId, int zivotinjaId)
        {
            var narudzba = await _context.Narudzbe.FirstOrDefaultAsync(x => x.NarudzbaId == narudzbaId);
            var zivotinja = await _context.Zivotinje.FirstOrDefaultAsync(x => x.ZivotinjaId == zivotinjaId);

            if (narudzba != null && zivotinja != null && zivotinja.StateMachine == "Reserved")
            {
                narudzba.TotalFinal -= zivotinja.Cijena;

                zivotinja.NarudzbaId = null;
                zivotinja.StateMachine = "Active";
                await _context.SaveChangesAsync();
                return _mapper.Map<DtoNarudzba>(narudzba);
            }
            return null;
        }

        public override async Task<DtoNarudzba> Update(int narudzbaId, UpdateNarudzba request)
        {
            var dbObj = await _context.Set<Narudzba>().FindAsync(narudzbaId);

            _mapper.Map(request, dbObj);

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoNarudzba>(dbObj);
        }

        public override async Task<DtoNarudzba> Activate(int narudzbaId)
        {
            var dbObj = await _context.Set<Narudzba>().FindAsync(narudzbaId);

            dbObj.StateMachine = "Active";

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoNarudzba>(dbObj);
        }

        public override async Task<DtoNarudzba> Delete(int narudzbaId)
        {
            var dbObj = await _context.Set<Narudzba>().FindAsync(narudzbaId);

            dbObj.StateMachine = "Deleted";

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoNarudzba>(dbObj);
        }
    }
}
