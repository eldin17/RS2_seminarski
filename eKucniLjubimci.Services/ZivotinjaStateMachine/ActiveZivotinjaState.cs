using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ZivotinjaStateMachine
{
    public class ActiveZivotinjaState : BaseZivotinjaState
    {
        public ActiveZivotinjaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<DtoZivotinja> Update(int id, UpdateZivotinja request)
        {
            var dbObj = await _context.Set<Zivotinja>().FindAsync(id);

            _mapper.Map(request, dbObj);

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoZivotinja>(dbObj);
        }

        public override async Task<DtoZivotinja> Delete(int id)
        {
            var dbObj = await _context.Set<Zivotinja>().FindAsync(id);

            dbObj.StateMachine = "Deleted";

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoZivotinja>(dbObj);
        }
    }
}
