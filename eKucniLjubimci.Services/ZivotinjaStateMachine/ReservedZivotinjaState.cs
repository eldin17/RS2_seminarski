using AutoMapper;
using eKucniLjubimci.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ZivotinjaStateMachine
{
    public class ReservedZivotinjaState : BaseZivotinjaState
    {
        public ReservedZivotinjaState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
    }
}
