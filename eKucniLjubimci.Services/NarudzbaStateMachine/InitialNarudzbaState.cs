using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.ArtikalStateMachine.RabbitMQType;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.NarudzbaStateMachine.RabbitMQType;
using Microsoft.Extensions.Configuration;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.NarudzbaStateMachine
{
    public class InitialNarudzbaState : BaseNarudzbaState
    {
        public InitialNarudzbaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<List<string>> AllowedActionsInState()
        {
            var actions = await base.AllowedActionsInState();
            actions.Add("Add");            
            return actions;
        }

        public override async Task<DtoNarudzba> Add(AddNarudzba request)
        {
            var obj = _mapper.Map<Narudzba>(request);

            obj.StateMachine = "Draft";
            _context.Set<Narudzba>().Add(obj);

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqNarudzba>(obj);
            mappedEntity.Funkcija = "Add";

            string message = $"\nPoruka funkcije {mappedEntity.Funkcija} \nUpravo je dodana nova narudzba \n-Id: {mappedEntity?.NarudzbaId} \n-Id kupca: {mappedEntity?.KupacId} \n-Datum: {mappedEntity?.DatumNarudzbe}";

            rmqMail.RabbitMQSend(message);

            return _mapper.Map<DtoNarudzba>(obj);
        }
    }
}
