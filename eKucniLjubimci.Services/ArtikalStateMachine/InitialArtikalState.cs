using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.ZivotinjaStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ArtikalStateMachine
{
    public class InitialArtikalState : BaseArtikalState
    {
        public InitialArtikalState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<List<string>> AllowedActionsInState()
        {
            var actions = await base.AllowedActionsInState();
            actions.Add("Add");
            return actions;
        }

        public override async Task<DtoArtikal> Add(AddArtikal request)
        {
            var obj = _mapper.Map<Artikal>(request);

            obj.StateMachine = "Draft";

            _context.Set<Artikal>().Add(obj);

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoArtikal>(obj);
        }
    }
}
