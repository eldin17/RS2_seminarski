﻿using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
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

        public override async Task<DtoNarudzba> Add(AddNarudzba request)
        {
            var obj = _mapper.Map<Narudzba>(request);

            obj.StateMachine = "Draft";

            _context.Set<Narudzba>().Add(obj);

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoNarudzba>(obj);
        }
    }
}
