﻿using AutoMapper;
using EasyNetQ;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.ArtikalStateMachine.RabbitMQType;
using eKucniLjubimci.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ArtikalStateMachine
{
    public class DraftArtikalState : BaseArtikalState
    {
        public DraftArtikalState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<List<string>> AllowedActionsInState()
        {
            var actions = await base.AllowedActionsInState();
            actions.Add("Update");
            actions.Add("Activate");
            actions.Add("Delete");
            actions.Add("AddSlike");
            return actions;
        }
        public override async Task<DtoArtikal> Update(int id, UpdateArtikal request)
        {
            var dbObj = await _context.Set<Artikal>().FindAsync(id);

            _mapper.Map(request, dbObj);

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqArtikal>(dbObj);
            mappedEntity.Funkcija = "Update";

            using var bus = RabbitHutch.CreateBus("host=ekucniljubimci-rmq");
            //using var bus = RabbitHutch.CreateBus("host=localhost");

            bus.PubSub.Publish(mappedEntity);

            return _mapper.Map<DtoArtikal>(dbObj);
        }

        public override async Task<DtoArtikal> Activate(int id)
        {
            var dbObj = await _context.Set<Artikal>().FindAsync(id);

            dbObj.StateMachine = "Active";

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqArtikal>(dbObj);
            mappedEntity.Funkcija = "Activate";

            using var bus = RabbitHutch.CreateBus("host=ekucniljubimci-rmq");
            //using var bus = RabbitHutch.CreateBus("host=localhost");

            bus.PubSub.Publish(mappedEntity);

            return _mapper.Map<DtoArtikal>(dbObj);
        }

        public override async Task<DtoArtikal> Delete(int id)
        {
            var dbObj = await _context.Set<Artikal>().FindAsync(id);

            dbObj.StateMachine = "Deleted";

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<rmqArtikal>(dbObj);
            mappedEntity.Funkcija = "Delete";

            using var bus = RabbitHutch.CreateBus("host=ekucniljubimci-rmq");
            //using var bus = RabbitHutch.CreateBus("host=localhost");

            bus.PubSub.Publish(mappedEntity);

            return _mapper.Map<DtoArtikal>(dbObj);
        }
    }
}
