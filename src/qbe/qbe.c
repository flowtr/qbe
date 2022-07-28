#include "qbe.h"

void data(Dat *d, FILE *outf) {
  if (d->type == DEnd) {
    fputs("/* end data */\n\n", outf);
    freeall();
  }
  gasemitdat(d, outf);
}

void func(Fn *fn, FILE *outf) {
  uint n;
  fillrpo(fn);
  fillpreds(fn);
  filluse(fn);
  memopt(fn);
  filluse(fn);
  ssa(fn);
  filluse(fn);
  ssacheck(fn);
  fillalias(fn);
  loadopt(fn);
  filluse(fn);
  ssacheck(fn);
  copy(fn);
  filluse(fn);
  fold(fn);
  T.abi(fn);
  fillpreds(fn);
  filluse(fn);
  T.isel(fn);
  fillrpo(fn);
  filllive(fn);
  fillloop(fn);
  fillcost(fn);
  spill(fn);
  rega(fn);
  fillrpo(fn);
  simpljmp(fn);
  fillpreds(fn);
  fillrpo(fn);
  assert(fn->rpo[0] == fn->start);
  for (n = 0;; n++)
    if (n == fn->nblk - 1) {
      fn->rpo[n]->link = 0;
      break;
    } else
      fn->rpo[n]->link = fn->rpo[n + 1];
#ifndef DEBUG
  T.emitfn(fn, outf);
  gasemitfntail(fn->name, outf);
  fprintf(outf, "/* end function %s */\n\n", fn->name);
#else
  fprintf(stderr, "\n");
#endif
  freeall();
}
