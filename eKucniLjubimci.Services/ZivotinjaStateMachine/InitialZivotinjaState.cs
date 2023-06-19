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
    public class InitialZivotinjaState : BaseZivotinjaState
    {
        public InitialZivotinjaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override async Task<DtoZivotinja> Add(AddZivotinja request)
        {
            var obj = _mapper.Map<Zivotinja>(request);

            obj.StateMachine = "Draft";

            _context.Set<Zivotinja>().Add(obj);

            await _context.SaveChangesAsync();
            return _mapper.Map<DtoZivotinja>(obj);
        }
    }
}
