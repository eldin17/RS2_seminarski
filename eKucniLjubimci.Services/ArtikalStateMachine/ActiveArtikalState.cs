﻿using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ArtikalStateMachine
{
    public class ActiveArtikalState : BaseArtikalState
    {
        public ActiveArtikalState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override async Task<DtoArtikal> Update(int id, UpdateArtikal request)
        {
            var dbObj = await _context.Set<Artikal>().FindAsync(id);

            _mapper.Map(request, dbObj);

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoArtikal>(dbObj);
        }

        public override async Task<DtoArtikal> Delete(int id)
        {
            var dbObj = await _context.Set<Artikal>().FindAsync(id);

            dbObj.StateMachine = "Deleted";

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoArtikal>(dbObj);
        }
    }
}