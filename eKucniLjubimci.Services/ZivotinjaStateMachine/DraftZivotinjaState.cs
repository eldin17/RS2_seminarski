using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.ZivotinjaStateMachine.RabbitMQType;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ZivotinjaStateMachine
{
    public class DraftZivotinjaState : BaseZivotinjaState
    {

        public DraftZivotinjaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<List<string>> AllowedActionsInState()
        {
            var actions = await base.AllowedActionsInState();
            actions.Add("Update");
            actions.Add("Activate");
            actions.Add("AddSlike");
            actions.Add("Delete");
            return actions;
        }

        public override async Task<DtoZivotinja> Update(int id, UpdateZivotinja request)
        {
            var dbObj = await _context.Set<Zivotinja>().FindAsync(id);

            _mapper.Map(request, dbObj);

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqZivotinja>(dbObj);
            mappedEntity.Funkcija = "Update";

            string message = $"\nPoruka funkcije {mappedEntity.Funkcija} \nUpravo je azurirana zivotinja \n-Id: {mappedEntity?.ZivotinjaId} \n-Naziv: {mappedEntity?.Naziv} \n-Cijena: {mappedEntity?.Cijena}";

            rmqMail.RabbitMQSend(message);

            return _mapper.Map<DtoZivotinja>(dbObj);
        }

        public override async Task<DtoZivotinja> Activate(int id)
        {
            var dbObj = await _context.Set<Zivotinja>().FindAsync(id);

            dbObj.StateMachine = "Active";

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqZivotinja>(dbObj);
            mappedEntity.Funkcija = "Activate";

            string message = $"\nPoruka funkcije {mappedEntity.Funkcija} \nUpravo je aktivirana zivotinja \n-Id: {mappedEntity?.ZivotinjaId} \n-Naziv: {mappedEntity?.Naziv} \n-Cijena: {mappedEntity?.Cijena}";

            rmqMail.RabbitMQSend(message);

            return _mapper.Map<DtoZivotinja>(dbObj);
        }

        public override async Task<DtoZivotinja> Delete(int id)
        {
            var dbObj = await _context.Set<Zivotinja>().FindAsync(id);

            dbObj.StateMachine = "Deleted";

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqZivotinja>(dbObj);
            mappedEntity.Funkcija = "Delete";

            string message = $"\nPoruka funkcije {mappedEntity.Funkcija} \nUpravo je izbrisana zivotinja \n-Id: {mappedEntity?.ZivotinjaId} \n-Naziv: {mappedEntity?.Naziv} \n-Cijena: {mappedEntity?.Cijena}";

            rmqMail.RabbitMQSend(message);

            return _mapper.Map<DtoZivotinja>(dbObj);
        }

       
    }
}
