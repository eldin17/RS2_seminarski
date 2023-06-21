using AutoMapper;
using EasyNetQ;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.ZivotinjaStateMachine.RabbitMQType;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ZivotinjaStateMachine
{
    public class InitialZivotinjaState : BaseZivotinjaState
    {
        public InitialZivotinjaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<List<string>> AllowedActionsInState()
        {
            var actions = await base.AllowedActionsInState();
            actions.Add("Add");            
            return actions;
        }

        public override async Task<DtoZivotinja> Add(AddZivotinja request)
        {
            var obj = _mapper.Map<Zivotinja>(request);

            obj.StateMachine = "Draft";

            _context.Set<Zivotinja>().Add(obj);

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqZivotinja>(obj);
            mappedEntity.Funkcija = "Add";

            using var bus = RabbitHutch.CreateBus("host=ekucniljubimci-rmq");
            //using var bus = RabbitHutch.CreateBus("host=localhost");

            bus.PubSub.Publish(mappedEntity);

            return _mapper.Map<DtoZivotinja>(obj);
        }
    }
}
