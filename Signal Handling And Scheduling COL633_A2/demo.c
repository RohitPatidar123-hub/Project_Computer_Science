// void scheduler(void)
// {
//   struct proc *p, *chosen = 0;
//   struct cpu *c = mycpu();
//   c->proc = 0;
//   for(;;){
//     // Enable interrupts on this processor.
//     sti();
//     acquire(&ptable.lock);
//     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//       //  if(p->state == UNUSED ){
//       //     continue;
//       //   }
//       //   if(p->suspended == 1 || p->state == SUSPENDED){
//       //     continue;
//       //   }
//       //   if(p->state != RUNNABLE){ 
//       //     //cprintf("Scheduler skipping suspended pid=%d name=%s  state=%d\n", p->pid, p->name , p->state);
//       //     continue;
//       //   }

//       if(p->has_started == 0) {
//         p->first_run_time = ticks;
//         p->has_started = 1;
//       }
//       p->context_switches++;     // PROFILER: Increment context switch count for each time a process is scheduled
//       chosen = p;
//       break;  // select the first RUNNABLE process
//     }
//    // PROFILER: For every process in RUNNABLE state that was not chosen,
//     // increment its waiting time (this represents the passage of one scheduler tick).
//     if(chosen){
//       for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//         if(p->state == RUNNABLE && p != chosen)
//           p->total_wait_time++;
//       }
//     }

//     // If a process was selected, switch to it.
//     if(chosen){
//       c->proc = chosen;
//       switchuvm(chosen);
//       chosen->state = RUNNING;
      
//       // Context switch: scheduler yields control to chosen process.
//       swtch(&(c->scheduler), chosen->context);
//       switchkvm();

//       // PROFILER: After the process yields (its time slice ends),
//       // increment its total run time (assume one tick per slice for simplicity).
//       chosen->total_run_time++;

//       // Process is done running for now.
//       c->proc = 0;
//       chosen = 0; // reset chosen pointer for the next iteration
//     }
//     release(&ptable.lock);
//   }
// }
