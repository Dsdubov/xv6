
kernel:     формат файла elf32-i386


Дизассемблирование раздела .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc b0 d7 10 80       	mov    $0x8010d7b0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 65 3b 10 80       	mov    $0x80103b65,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 98 8d 10 80       	push   $0x80108d98
80100042:	68 c0 d7 10 80       	push   $0x8010d7c0
80100047:	e8 7c 52 00 00       	call   801052c8 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 d0 16 11 80 c4 	movl   $0x801116c4,0x801116d0
80100056:	16 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 d4 16 11 80 c4 	movl   $0x801116c4,0x801116d4
80100060:	16 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 f4 d7 10 80 	movl   $0x8010d7f4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 d4 16 11 80    	mov    0x801116d4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c c4 16 11 80 	movl   $0x801116c4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 d4 16 11 80       	mov    %eax,0x801116d4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 c4 16 11 80       	mov    $0x801116c4,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 c0 d7 10 80       	push   $0x8010d7c0
801000c1:	e8 24 52 00 00       	call   801052ea <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 d4 16 11 80       	mov    0x801116d4,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 c0 d7 10 80       	push   $0x8010d7c0
8010010c:	e8 40 52 00 00       	call   80105351 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 c0 d7 10 80       	push   $0x8010d7c0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 bc 4e 00 00       	call   80104fe8 <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 c4 16 11 80 	cmpl   $0x801116c4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 d0 16 11 80       	mov    0x801116d0,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 c0 d7 10 80       	push   $0x8010d7c0
80100188:	e8 c4 51 00 00       	call   80105351 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 c4 16 11 80 	cmpl   $0x801116c4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 9f 8d 10 80       	push   $0x80108d9f
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 fc 29 00 00       	call   80102be3 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 b0 8d 10 80       	push   $0x80108db0
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 bb 29 00 00       	call   80102be3 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 b7 8d 10 80       	push   $0x80108db7
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 c0 d7 10 80       	push   $0x8010d7c0
80100255:	e8 90 50 00 00       	call   801052ea <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 d4 16 11 80    	mov    0x801116d4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c c4 16 11 80 	movl   $0x801116c4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 d4 16 11 80       	mov    %eax,0x801116d4

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 18 4e 00 00       	call   801050d6 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 c0 d7 10 80       	push   $0x8010d7c0
801002c9:	e8 83 50 00 00       	call   80105351 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 c3 03 00 00       	call   80100776 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 c6 10 80       	push   $0x8010c600
801003e2:	e8 03 4f 00 00       	call   801052ea <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 be 8d 10 80       	push   $0x80108dbe
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 55 03 00 00       	call   80100776 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec c7 8d 10 80 	movl   $0x80108dc7,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 8e 02 00 00       	call   80100776 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 71 02 00 00       	call   80100776 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 62 02 00 00       	call   80100776 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 54 02 00 00       	call   80100776 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 00 c6 10 80       	push   $0x8010c600
8010055b:	e8 f1 4d 00 00       	call   80105351 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 34 c6 10 80 00 	movl   $0x0,0x8010c634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 ce 8d 10 80       	push   $0x80108dce
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 dd 8d 10 80       	push   $0x80108ddd
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 dc 4d 00 00       	call   801053a3 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 df 8d 10 80       	push   $0x80108ddf
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006b8:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006bf:	7e 4c                	jle    8010070d <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006c1:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006c6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006cc:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006d1:	83 ec 04             	sub    $0x4,%esp
801006d4:	68 60 0e 00 00       	push   $0xe60
801006d9:	52                   	push   %edx
801006da:	50                   	push   %eax
801006db:	e8 2c 4f 00 00       	call   8010560c <memmove>
801006e0:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006e3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006e7:	b8 80 07 00 00       	mov    $0x780,%eax
801006ec:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006ef:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006f2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006fa:	01 c9                	add    %ecx,%ecx
801006fc:	01 c8                	add    %ecx,%eax
801006fe:	83 ec 04             	sub    $0x4,%esp
80100701:	52                   	push   %edx
80100702:	6a 00                	push   $0x0
80100704:	50                   	push   %eax
80100705:	e8 43 4e 00 00       	call   8010554d <memset>
8010070a:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010070d:	83 ec 08             	sub    $0x8,%esp
80100710:	6a 0e                	push   $0xe
80100712:	68 d4 03 00 00       	push   $0x3d4
80100717:	e8 d5 fb ff ff       	call   801002f1 <outb>
8010071c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100722:	c1 f8 08             	sar    $0x8,%eax
80100725:	0f b6 c0             	movzbl %al,%eax
80100728:	83 ec 08             	sub    $0x8,%esp
8010072b:	50                   	push   %eax
8010072c:	68 d5 03 00 00       	push   $0x3d5
80100731:	e8 bb fb ff ff       	call   801002f1 <outb>
80100736:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100739:	83 ec 08             	sub    $0x8,%esp
8010073c:	6a 0f                	push   $0xf
8010073e:	68 d4 03 00 00       	push   $0x3d4
80100743:	e8 a9 fb ff ff       	call   801002f1 <outb>
80100748:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010074e:	0f b6 c0             	movzbl %al,%eax
80100751:	83 ec 08             	sub    $0x8,%esp
80100754:	50                   	push   %eax
80100755:	68 d5 03 00 00       	push   $0x3d5
8010075a:	e8 92 fb ff ff       	call   801002f1 <outb>
8010075f:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100762:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100767:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010076a:	01 d2                	add    %edx,%edx
8010076c:	01 d0                	add    %edx,%eax
8010076e:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100773:	90                   	nop
80100774:	c9                   	leave  
80100775:	c3                   	ret    

80100776 <consputc>:

void
consputc(int c)
{
80100776:	55                   	push   %ebp
80100777:	89 e5                	mov    %esp,%ebp
80100779:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010077c:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
80100781:	85 c0                	test   %eax,%eax
80100783:	74 07                	je     8010078c <consputc+0x16>
    cli();
80100785:	e8 86 fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
8010078a:	eb fe                	jmp    8010078a <consputc+0x14>
  }

  if(c == BACKSPACE){
8010078c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100793:	75 29                	jne    801007be <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100795:	83 ec 0c             	sub    $0xc,%esp
80100798:	6a 08                	push   $0x8
8010079a:	e8 80 6c 00 00       	call   8010741f <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 73 6c 00 00       	call   8010741f <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 66 6c 00 00       	call   8010741f <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 56 6c 00 00       	call   8010741f <uartputc>
801007c9:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007cc:	83 ec 0c             	sub    $0xc,%esp
801007cf:	ff 75 08             	pushl  0x8(%ebp)
801007d2:	e8 2a fe ff ff       	call   80100601 <cgaputc>
801007d7:	83 c4 10             	add    $0x10,%esp
}
801007da:	90                   	nop
801007db:	c9                   	leave  
801007dc:	c3                   	ret    

801007dd <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007dd:	55                   	push   %ebp
801007de:	89 e5                	mov    %esp,%ebp
801007e0:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 e0 18 11 80       	push   $0x801118e0
801007eb:	e8 fa 4a 00 00       	call   801052ea <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007f3:	e9 42 01 00 00       	jmp    8010093a <consoleintr+0x15d>
    switch(c){
801007f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007fb:	83 f8 10             	cmp    $0x10,%eax
801007fe:	74 1e                	je     8010081e <consoleintr+0x41>
80100800:	83 f8 10             	cmp    $0x10,%eax
80100803:	7f 0a                	jg     8010080f <consoleintr+0x32>
80100805:	83 f8 08             	cmp    $0x8,%eax
80100808:	74 69                	je     80100873 <consoleintr+0x96>
8010080a:	e9 99 00 00 00       	jmp    801008a8 <consoleintr+0xcb>
8010080f:	83 f8 15             	cmp    $0x15,%eax
80100812:	74 31                	je     80100845 <consoleintr+0x68>
80100814:	83 f8 7f             	cmp    $0x7f,%eax
80100817:	74 5a                	je     80100873 <consoleintr+0x96>
80100819:	e9 8a 00 00 00       	jmp    801008a8 <consoleintr+0xcb>
    case C('P'):  // Process listing.
      procdump();
8010081e:	e8 71 49 00 00       	call   80105194 <procdump>
      break;
80100823:	e9 12 01 00 00       	jmp    8010093a <consoleintr+0x15d>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100828:	a1 9c 19 11 80       	mov    0x8011199c,%eax
8010082d:	83 e8 01             	sub    $0x1,%eax
80100830:	a3 9c 19 11 80       	mov    %eax,0x8011199c
        consputc(BACKSPACE);
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 00 01 00 00       	push   $0x100
8010083d:	e8 34 ff ff ff       	call   80100776 <consputc>
80100842:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100845:	8b 15 9c 19 11 80    	mov    0x8011199c,%edx
8010084b:	a1 98 19 11 80       	mov    0x80111998,%eax
80100850:	39 c2                	cmp    %eax,%edx
80100852:	0f 84 e2 00 00 00    	je     8010093a <consoleintr+0x15d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100858:	a1 9c 19 11 80       	mov    0x8011199c,%eax
8010085d:	83 e8 01             	sub    $0x1,%eax
80100860:	83 e0 7f             	and    $0x7f,%eax
80100863:	0f b6 80 14 19 11 80 	movzbl -0x7feee6ec(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010086a:	3c 0a                	cmp    $0xa,%al
8010086c:	75 ba                	jne    80100828 <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010086e:	e9 c7 00 00 00       	jmp    8010093a <consoleintr+0x15d>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100873:	8b 15 9c 19 11 80    	mov    0x8011199c,%edx
80100879:	a1 98 19 11 80       	mov    0x80111998,%eax
8010087e:	39 c2                	cmp    %eax,%edx
80100880:	0f 84 b4 00 00 00    	je     8010093a <consoleintr+0x15d>
        input.e--;
80100886:	a1 9c 19 11 80       	mov    0x8011199c,%eax
8010088b:	83 e8 01             	sub    $0x1,%eax
8010088e:	a3 9c 19 11 80       	mov    %eax,0x8011199c
        consputc(BACKSPACE);
80100893:	83 ec 0c             	sub    $0xc,%esp
80100896:	68 00 01 00 00       	push   $0x100
8010089b:	e8 d6 fe ff ff       	call   80100776 <consputc>
801008a0:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008a3:	e9 92 00 00 00       	jmp    8010093a <consoleintr+0x15d>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008ac:	0f 84 87 00 00 00    	je     80100939 <consoleintr+0x15c>
801008b2:	8b 15 9c 19 11 80    	mov    0x8011199c,%edx
801008b8:	a1 94 19 11 80       	mov    0x80111994,%eax
801008bd:	29 c2                	sub    %eax,%edx
801008bf:	89 d0                	mov    %edx,%eax
801008c1:	83 f8 7f             	cmp    $0x7f,%eax
801008c4:	77 73                	ja     80100939 <consoleintr+0x15c>
        c = (c == '\r') ? '\n' : c;
801008c6:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008ca:	74 05                	je     801008d1 <consoleintr+0xf4>
801008cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008cf:	eb 05                	jmp    801008d6 <consoleintr+0xf9>
801008d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801008d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008d9:	a1 9c 19 11 80       	mov    0x8011199c,%eax
801008de:	8d 50 01             	lea    0x1(%eax),%edx
801008e1:	89 15 9c 19 11 80    	mov    %edx,0x8011199c
801008e7:	83 e0 7f             	and    $0x7f,%eax
801008ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008ed:	88 90 14 19 11 80    	mov    %dl,-0x7feee6ec(%eax)
        consputc(c);
801008f3:	83 ec 0c             	sub    $0xc,%esp
801008f6:	ff 75 f4             	pushl  -0xc(%ebp)
801008f9:	e8 78 fe ff ff       	call   80100776 <consputc>
801008fe:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100901:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100905:	74 18                	je     8010091f <consoleintr+0x142>
80100907:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
8010090b:	74 12                	je     8010091f <consoleintr+0x142>
8010090d:	a1 9c 19 11 80       	mov    0x8011199c,%eax
80100912:	8b 15 94 19 11 80    	mov    0x80111994,%edx
80100918:	83 ea 80             	sub    $0xffffff80,%edx
8010091b:	39 d0                	cmp    %edx,%eax
8010091d:	75 1a                	jne    80100939 <consoleintr+0x15c>
          input.w = input.e;
8010091f:	a1 9c 19 11 80       	mov    0x8011199c,%eax
80100924:	a3 98 19 11 80       	mov    %eax,0x80111998
          wakeup(&input.r);
80100929:	83 ec 0c             	sub    $0xc,%esp
8010092c:	68 94 19 11 80       	push   $0x80111994
80100931:	e8 a0 47 00 00       	call   801050d6 <wakeup>
80100936:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100939:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010093a:	8b 45 08             	mov    0x8(%ebp),%eax
8010093d:	ff d0                	call   *%eax
8010093f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100946:	0f 89 ac fe ff ff    	jns    801007f8 <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010094c:	83 ec 0c             	sub    $0xc,%esp
8010094f:	68 e0 18 11 80       	push   $0x801118e0
80100954:	e8 f8 49 00 00       	call   80105351 <release>
80100959:	83 c4 10             	add    $0x10,%esp
}
8010095c:	90                   	nop
8010095d:	c9                   	leave  
8010095e:	c3                   	ret    

8010095f <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010095f:	55                   	push   %ebp
80100960:	89 e5                	mov    %esp,%ebp
80100962:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100965:	83 ec 0c             	sub    $0xc,%esp
80100968:	ff 75 08             	pushl  0x8(%ebp)
8010096b:	e8 2e 14 00 00       	call   80101d9e <iunlock>
80100970:	83 c4 10             	add    $0x10,%esp
  target = n;
80100973:	8b 45 10             	mov    0x10(%ebp),%eax
80100976:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100979:	83 ec 0c             	sub    $0xc,%esp
8010097c:	68 e0 18 11 80       	push   $0x801118e0
80100981:	e8 64 49 00 00       	call   801052ea <acquire>
80100986:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100989:	e9 ac 00 00 00       	jmp    80100a3a <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
8010098e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100994:	8b 40 24             	mov    0x24(%eax),%eax
80100997:	85 c0                	test   %eax,%eax
80100999:	74 28                	je     801009c3 <consoleread+0x64>
        release(&input.lock);
8010099b:	83 ec 0c             	sub    $0xc,%esp
8010099e:	68 e0 18 11 80       	push   $0x801118e0
801009a3:	e8 a9 49 00 00       	call   80105351 <release>
801009a8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009ab:	83 ec 0c             	sub    $0xc,%esp
801009ae:	ff 75 08             	pushl  0x8(%ebp)
801009b1:	e8 8a 12 00 00       	call   80101c40 <ilock>
801009b6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009be:	e9 ab 00 00 00       	jmp    80100a6e <consoleread+0x10f>
      }
      sleep(&input.r, &input.lock);
801009c3:	83 ec 08             	sub    $0x8,%esp
801009c6:	68 e0 18 11 80       	push   $0x801118e0
801009cb:	68 94 19 11 80       	push   $0x80111994
801009d0:	e8 13 46 00 00       	call   80104fe8 <sleep>
801009d5:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009d8:	8b 15 94 19 11 80    	mov    0x80111994,%edx
801009de:	a1 98 19 11 80       	mov    0x80111998,%eax
801009e3:	39 c2                	cmp    %eax,%edx
801009e5:	74 a7                	je     8010098e <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009e7:	a1 94 19 11 80       	mov    0x80111994,%eax
801009ec:	8d 50 01             	lea    0x1(%eax),%edx
801009ef:	89 15 94 19 11 80    	mov    %edx,0x80111994
801009f5:	83 e0 7f             	and    $0x7f,%eax
801009f8:	0f b6 80 14 19 11 80 	movzbl -0x7feee6ec(%eax),%eax
801009ff:	0f be c0             	movsbl %al,%eax
80100a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a05:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a09:	75 17                	jne    80100a22 <consoleread+0xc3>
      if(n < target){
80100a0b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a11:	73 2f                	jae    80100a42 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a13:	a1 94 19 11 80       	mov    0x80111994,%eax
80100a18:	83 e8 01             	sub    $0x1,%eax
80100a1b:	a3 94 19 11 80       	mov    %eax,0x80111994
      }
      break;
80100a20:	eb 20                	jmp    80100a42 <consoleread+0xe3>
    }
    *dst++ = c;
80100a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a25:	8d 50 01             	lea    0x1(%eax),%edx
80100a28:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a2e:	88 10                	mov    %dl,(%eax)
    --n;
80100a30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a34:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a38:	74 0b                	je     80100a45 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a3e:	7f 98                	jg     801009d8 <consoleread+0x79>
80100a40:	eb 04                	jmp    80100a46 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a42:	90                   	nop
80100a43:	eb 01                	jmp    80100a46 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a45:	90                   	nop
  }
  release(&input.lock);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	68 e0 18 11 80       	push   $0x801118e0
80100a4e:	e8 fe 48 00 00       	call   80105351 <release>
80100a53:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a56:	83 ec 0c             	sub    $0xc,%esp
80100a59:	ff 75 08             	pushl  0x8(%ebp)
80100a5c:	e8 df 11 00 00       	call   80101c40 <ilock>
80100a61:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a64:	8b 45 10             	mov    0x10(%ebp),%eax
80100a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a6a:	29 c2                	sub    %eax,%edx
80100a6c:	89 d0                	mov    %edx,%eax
}
80100a6e:	c9                   	leave  
80100a6f:	c3                   	ret    

80100a70 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	ff 75 08             	pushl  0x8(%ebp)
80100a7c:	e8 1d 13 00 00       	call   80101d9e <iunlock>
80100a81:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a84:	83 ec 0c             	sub    $0xc,%esp
80100a87:	68 00 c6 10 80       	push   $0x8010c600
80100a8c:	e8 59 48 00 00       	call   801052ea <acquire>
80100a91:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a9b:	eb 21                	jmp    80100abe <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aa3:	01 d0                	add    %edx,%eax
80100aa5:	0f b6 00             	movzbl (%eax),%eax
80100aa8:	0f be c0             	movsbl %al,%eax
80100aab:	0f b6 c0             	movzbl %al,%eax
80100aae:	83 ec 0c             	sub    $0xc,%esp
80100ab1:	50                   	push   %eax
80100ab2:	e8 bf fc ff ff       	call   80100776 <consputc>
80100ab7:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ac1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ac4:	7c d7                	jl     80100a9d <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ac6:	83 ec 0c             	sub    $0xc,%esp
80100ac9:	68 00 c6 10 80       	push   $0x8010c600
80100ace:	e8 7e 48 00 00       	call   80105351 <release>
80100ad3:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	ff 75 08             	pushl  0x8(%ebp)
80100adc:	e8 5f 11 00 00       	call   80101c40 <ilock>
80100ae1:	83 c4 10             	add    $0x10,%esp

  return n;
80100ae4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ae7:	c9                   	leave  
80100ae8:	c3                   	ret    

80100ae9 <consoleinit>:

void
consoleinit(void)
{
80100ae9:	55                   	push   %ebp
80100aea:	89 e5                	mov    %esp,%ebp
80100aec:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100aef:	83 ec 08             	sub    $0x8,%esp
80100af2:	68 e3 8d 10 80       	push   $0x80108de3
80100af7:	68 00 c6 10 80       	push   $0x8010c600
80100afc:	e8 c7 47 00 00       	call   801052c8 <initlock>
80100b01:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b04:	83 ec 08             	sub    $0x8,%esp
80100b07:	68 eb 8d 10 80       	push   $0x80108deb
80100b0c:	68 e0 18 11 80       	push   $0x801118e0
80100b11:	e8 b2 47 00 00       	call   801052c8 <initlock>
80100b16:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b19:	c7 05 4c 23 11 80 70 	movl   $0x80100a70,0x8011234c
80100b20:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b23:	c7 05 48 23 11 80 5f 	movl   $0x8010095f,0x80112348
80100b2a:	09 10 80 
  cons.locking = 1;
80100b2d:	c7 05 34 c6 10 80 01 	movl   $0x1,0x8010c634
80100b34:	00 00 00 

  picenable(IRQ_KBD);
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	6a 01                	push   $0x1
80100b3c:	e8 c0 36 00 00       	call   80104201 <picenable>
80100b41:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b44:	83 ec 08             	sub    $0x8,%esp
80100b47:	6a 00                	push   $0x0
80100b49:	6a 01                	push   $0x1
80100b4b:	e8 60 22 00 00       	call   80102db0 <ioapicenable>
80100b50:	83 c4 10             	add    $0x10,%esp
}
80100b53:	90                   	nop
80100b54:	c9                   	leave  
80100b55:	c3                   	ret    

80100b56 <_exec>:

int rec_lim = 0;
const int MAX_LIM = 5;


int _exec(char * path, char ** argv){
80100b56:	55                   	push   %ebp
80100b57:	89 e5                	mov    %esp,%ebp
80100b59:	83 ec 08             	sub    $0x8,%esp
  ++rec_lim;
80100b5c:	a1 38 c6 10 80       	mov    0x8010c638,%eax
80100b61:	83 c0 01             	add    $0x1,%eax
80100b64:	a3 38 c6 10 80       	mov    %eax,0x8010c638
  if (rec_lim < MAX_LIM)
80100b69:	a1 38 c6 10 80       	mov    0x8010c638,%eax
80100b6e:	ba 05 00 00 00       	mov    $0x5,%edx
80100b73:	39 d0                	cmp    %edx,%eax
80100b75:	7d 13                	jge    80100b8a <_exec+0x34>
    return exec(path, argv);
80100b77:	83 ec 08             	sub    $0x8,%esp
80100b7a:	ff 75 0c             	pushl  0xc(%ebp)
80100b7d:	ff 75 08             	pushl  0x8(%ebp)
80100b80:	e8 0c 00 00 00       	call   80100b91 <exec>
80100b85:	83 c4 10             	add    $0x10,%esp
80100b88:	eb 05                	jmp    80100b8f <_exec+0x39>
  else
    return -1;   
80100b8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b8f:	c9                   	leave  
80100b90:	c3                   	ret    

80100b91 <exec>:

int
exec(char *path, char **argv)
{
80100b91:	55                   	push   %ebp
80100b92:	89 e5                	mov    %esp,%ebp
80100b94:	53                   	push   %ebx
80100b95:	81 ec 34 01 00 00    	sub    $0x134,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b9b:	e8 83 2c 00 00       	call   80103823 <begin_op>
  if((ip = namei(path)) == 0) {
80100ba0:	83 ec 0c             	sub    $0xc,%esp
80100ba3:	ff 75 08             	pushl  0x8(%ebp)
80100ba6:	e8 53 1c 00 00       	call   801027fe <namei>
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bb1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bb5:	75 0f                	jne    80100bc6 <exec+0x35>
    end_op();
80100bb7:	e8 f3 2c 00 00       	call   801038af <end_op>
    return -1;
80100bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc1:	e9 45 05 00 00       	jmp    8010110b <exec+0x57a>
  }
  ilock(ip);
80100bc6:	83 ec 0c             	sub    $0xc,%esp
80100bc9:	ff 75 d8             	pushl  -0x28(%ebp)
80100bcc:	e8 6f 10 00 00       	call   80101c40 <ilock>
80100bd1:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bd4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)


  // check #!
    char sh[2];
    char buf[1];
    char * interp = kalloc();
80100bdb:	e8 5c 23 00 00       	call   80102f3c <kalloc>
80100be0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    char * p = interp;
80100be3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80100be6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    int nArgc = 0;
80100be9:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
    int k;
    int j;
    if (readi(ip, sh, 0, 2) > 0) {
80100bf0:	6a 02                	push   $0x2
80100bf2:	6a 00                	push   $0x0
80100bf4:	8d 85 ca fe ff ff    	lea    -0x136(%ebp),%eax
80100bfa:	50                   	push   %eax
80100bfb:	ff 75 d8             	pushl  -0x28(%ebp)
80100bfe:	e8 ab 15 00 00       	call   801021ae <readi>
80100c03:	83 c4 10             	add    $0x10,%esp
80100c06:	85 c0                	test   %eax,%eax
80100c08:	0f 8e 44 01 00 00    	jle    80100d52 <exec+0x1c1>
      if (sh[0] == '#' && sh[1] == '!') {
80100c0e:	0f b6 85 ca fe ff ff 	movzbl -0x136(%ebp),%eax
80100c15:	3c 23                	cmp    $0x23,%al
80100c17:	0f 85 35 01 00 00    	jne    80100d52 <exec+0x1c1>
80100c1d:	0f b6 85 cb fe ff ff 	movzbl -0x135(%ebp),%eax
80100c24:	3c 21                	cmp    $0x21,%al
80100c26:	0f 85 26 01 00 00    	jne    80100d52 <exec+0x1c1>
        for(j = 2; readi(ip, buf, j, 1) == 1 && buf[0] != '\n'; ++j){
80100c2c:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
80100c33:	eb 16                	jmp    80100c4b <exec+0xba>
          *p++ = buf[0];
80100c35:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100c38:	8d 50 01             	lea    0x1(%eax),%edx
80100c3b:	89 55 d0             	mov    %edx,-0x30(%ebp)
80100c3e:	0f b6 95 c9 fe ff ff 	movzbl -0x137(%ebp),%edx
80100c45:	88 10                	mov    %dl,(%eax)
    int nArgc = 0;
    int k;
    int j;
    if (readi(ip, sh, 0, 2) > 0) {
      if (sh[0] == '#' && sh[1] == '!') {
        for(j = 2; readi(ip, buf, j, 1) == 1 && buf[0] != '\n'; ++j){
80100c47:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
80100c4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80100c4e:	6a 01                	push   $0x1
80100c50:	50                   	push   %eax
80100c51:	8d 85 c9 fe ff ff    	lea    -0x137(%ebp),%eax
80100c57:	50                   	push   %eax
80100c58:	ff 75 d8             	pushl  -0x28(%ebp)
80100c5b:	e8 4e 15 00 00       	call   801021ae <readi>
80100c60:	83 c4 10             	add    $0x10,%esp
80100c63:	83 f8 01             	cmp    $0x1,%eax
80100c66:	75 0b                	jne    80100c73 <exec+0xe2>
80100c68:	0f b6 85 c9 fe ff ff 	movzbl -0x137(%ebp),%eax
80100c6f:	3c 0a                	cmp    $0xa,%al
80100c71:	75 c2                	jne    80100c35 <exec+0xa4>
          *p++ = buf[0];
        }
        *p = '\0';
80100c73:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100c76:	c6 00 00             	movb   $0x0,(%eax)
        for (; argv[nArgc]; ++nArgc);
80100c79:	eb 04                	jmp    80100c7f <exec+0xee>
80100c7b:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
80100c7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100c82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100c89:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8c:	01 d0                	add    %edx,%eax
80100c8e:	8b 00                	mov    (%eax),%eax
80100c90:	85 c0                	test   %eax,%eax
80100c92:	75 e7                	jne    80100c7b <exec+0xea>
        char * nArgv[nArgc + 1];
80100c94:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100c97:	83 c0 01             	add    $0x1,%eax
80100c9a:	89 e2                	mov    %esp,%edx
80100c9c:	89 d3                	mov    %edx,%ebx
80100c9e:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ca1:	89 55 bc             	mov    %edx,-0x44(%ebp)
80100ca4:	c1 e0 02             	shl    $0x2,%eax
80100ca7:	8d 50 03             	lea    0x3(%eax),%edx
80100caa:	b8 10 00 00 00       	mov    $0x10,%eax
80100caf:	83 e8 01             	sub    $0x1,%eax
80100cb2:	01 d0                	add    %edx,%eax
80100cb4:	b9 10 00 00 00       	mov    $0x10,%ecx
80100cb9:	ba 00 00 00 00       	mov    $0x0,%edx
80100cbe:	f7 f1                	div    %ecx
80100cc0:	6b c0 10             	imul   $0x10,%eax,%eax
80100cc3:	29 c4                	sub    %eax,%esp
80100cc5:	89 e0                	mov    %esp,%eax
80100cc7:	83 c0 03             	add    $0x3,%eax
80100cca:	c1 e8 02             	shr    $0x2,%eax
80100ccd:	c1 e0 02             	shl    $0x2,%eax
80100cd0:	89 45 b8             	mov    %eax,-0x48(%ebp)
        nArgv[0] = interp;
80100cd3:	8b 45 b8             	mov    -0x48(%ebp),%eax
80100cd6:	8b 55 c0             	mov    -0x40(%ebp),%edx
80100cd9:	89 10                	mov    %edx,(%eax)
        for (k = 1; k <= nArgc + 1; ++k)
80100cdb:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
80100ce2:	eb 23                	jmp    80100d07 <exec+0x176>
          nArgv[k] = argv[k - 1];
80100ce4:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100ce7:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
80100cec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf6:	01 d0                	add    %edx,%eax
80100cf8:	8b 08                	mov    (%eax),%ecx
80100cfa:	8b 45 b8             	mov    -0x48(%ebp),%eax
80100cfd:	8b 55 c8             	mov    -0x38(%ebp),%edx
80100d00:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
        }
        *p = '\0';
        for (; argv[nArgc]; ++nArgc);
        char * nArgv[nArgc + 1];
        nArgv[0] = interp;
        for (k = 1; k <= nArgc + 1; ++k)
80100d03:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
80100d07:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100d0a:	83 c0 01             	add    $0x1,%eax
80100d0d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
80100d10:	7d d2                	jge    80100ce4 <exec+0x153>
          nArgv[k] = argv[k - 1];
        iunlockput(ip);
80100d12:	83 ec 0c             	sub    $0xc,%esp
80100d15:	ff 75 d8             	pushl  -0x28(%ebp)
80100d18:	e8 e3 11 00 00       	call   80101f00 <iunlockput>
80100d1d:	83 c4 10             	add    $0x10,%esp
        end_op();
80100d20:	e8 8a 2b 00 00       	call   801038af <end_op>
        int res = _exec(interp, nArgv);
80100d25:	8b 45 b8             	mov    -0x48(%ebp),%eax
80100d28:	83 ec 08             	sub    $0x8,%esp
80100d2b:	50                   	push   %eax
80100d2c:	ff 75 c0             	pushl  -0x40(%ebp)
80100d2f:	e8 22 fe ff ff       	call   80100b56 <_exec>
80100d34:	83 c4 10             	add    $0x10,%esp
80100d37:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        kfree(interp);
80100d3a:	83 ec 0c             	sub    $0xc,%esp
80100d3d:	ff 75 c0             	pushl  -0x40(%ebp)
80100d40:	e8 5a 21 00 00       	call   80102e9f <kfree>
80100d45:	83 c4 10             	add    $0x10,%esp
        return res;
80100d48:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80100d4b:	89 dc                	mov    %ebx,%esp
80100d4d:	e9 b9 03 00 00       	jmp    8010110b <exec+0x57a>
      }
    }


  // Check ELF header 
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf)) {
80100d52:	6a 34                	push   $0x34
80100d54:	6a 00                	push   $0x0
80100d56:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100d5c:	50                   	push   %eax
80100d5d:	ff 75 d8             	pushl  -0x28(%ebp)
80100d60:	e8 49 14 00 00       	call   801021ae <readi>
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	83 f8 33             	cmp    $0x33,%eax
80100d6b:	0f 86 49 03 00 00    	jbe    801010ba <exec+0x529>
    goto bad;
  }
  if(elf.magic != ELF_MAGIC) {
80100d71:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d77:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100d7c:	0f 85 3b 03 00 00    	jne    801010bd <exec+0x52c>
    goto bad;
  }
  if((pgdir = setupkvm()) == 0) {
80100d82:	e8 ed 77 00 00       	call   80108574 <setupkvm>
80100d87:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100d8a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100d8e:	0f 84 2c 03 00 00    	je     801010c0 <exec+0x52f>
    goto bad;
  }

  // Load program into memory.
  sz = 0;
80100d94:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d9b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100da2:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100da8:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100dab:	e9 ab 00 00 00       	jmp    80100e5b <exec+0x2ca>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100db0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100db3:	6a 20                	push   $0x20
80100db5:	50                   	push   %eax
80100db6:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
80100dbc:	50                   	push   %eax
80100dbd:	ff 75 d8             	pushl  -0x28(%ebp)
80100dc0:	e8 e9 13 00 00       	call   801021ae <readi>
80100dc5:	83 c4 10             	add    $0x10,%esp
80100dc8:	83 f8 20             	cmp    $0x20,%eax
80100dcb:	0f 85 f2 02 00 00    	jne    801010c3 <exec+0x532>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100dd1:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
80100dd7:	83 f8 01             	cmp    $0x1,%eax
80100dda:	75 71                	jne    80100e4d <exec+0x2bc>
      continue;
    if(ph.memsz < ph.filesz)
80100ddc:	8b 95 e0 fe ff ff    	mov    -0x120(%ebp),%edx
80100de2:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
80100de8:	39 c2                	cmp    %eax,%edx
80100dea:	0f 82 d6 02 00 00    	jb     801010c6 <exec+0x535>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100df0:	8b 95 d4 fe ff ff    	mov    -0x12c(%ebp),%edx
80100df6:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
80100dfc:	01 d0                	add    %edx,%eax
80100dfe:	83 ec 04             	sub    $0x4,%esp
80100e01:	50                   	push   %eax
80100e02:	ff 75 e0             	pushl  -0x20(%ebp)
80100e05:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e08:	e8 0e 7b 00 00       	call   8010891b <allocuvm>
80100e0d:	83 c4 10             	add    $0x10,%esp
80100e10:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e13:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e17:	0f 84 ac 02 00 00    	je     801010c9 <exec+0x538>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e1d:	8b 95 dc fe ff ff    	mov    -0x124(%ebp),%edx
80100e23:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
80100e29:	8b 8d d4 fe ff ff    	mov    -0x12c(%ebp),%ecx
80100e2f:	83 ec 0c             	sub    $0xc,%esp
80100e32:	52                   	push   %edx
80100e33:	50                   	push   %eax
80100e34:	ff 75 d8             	pushl  -0x28(%ebp)
80100e37:	51                   	push   %ecx
80100e38:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e3b:	e8 04 7a 00 00       	call   80108844 <loaduvm>
80100e40:	83 c4 20             	add    $0x20,%esp
80100e43:	85 c0                	test   %eax,%eax
80100e45:	0f 88 81 02 00 00    	js     801010cc <exec+0x53b>
80100e4b:	eb 01                	jmp    80100e4e <exec+0x2bd>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100e4d:	90                   	nop
    goto bad;
  }

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e4e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100e55:	83 c0 20             	add    $0x20,%eax
80100e58:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100e5b:	0f b7 85 18 ff ff ff 	movzwl -0xe8(%ebp),%eax
80100e62:	0f b7 c0             	movzwl %ax,%eax
80100e65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100e68:	0f 8f 42 ff ff ff    	jg     80100db0 <exec+0x21f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100e6e:	83 ec 0c             	sub    $0xc,%esp
80100e71:	ff 75 d8             	pushl  -0x28(%ebp)
80100e74:	e8 87 10 00 00       	call   80101f00 <iunlockput>
80100e79:	83 c4 10             	add    $0x10,%esp
  end_op();
80100e7c:	e8 2e 2a 00 00       	call   801038af <end_op>
  ip = 0;
80100e81:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e8b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e9b:	05 00 20 00 00       	add    $0x2000,%eax
80100ea0:	83 ec 04             	sub    $0x4,%esp
80100ea3:	50                   	push   %eax
80100ea4:	ff 75 e0             	pushl  -0x20(%ebp)
80100ea7:	ff 75 d4             	pushl  -0x2c(%ebp)
80100eaa:	e8 6c 7a 00 00       	call   8010891b <allocuvm>
80100eaf:	83 c4 10             	add    $0x10,%esp
80100eb2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100eb5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100eb9:	0f 84 10 02 00 00    	je     801010cf <exec+0x53e>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec2:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ec7:	83 ec 08             	sub    $0x8,%esp
80100eca:	50                   	push   %eax
80100ecb:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ece:	e8 6e 7c 00 00       	call   80108b41 <clearpteu>
80100ed3:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100ed6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ed9:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100edc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100ee3:	e9 96 00 00 00       	jmp    80100f7e <exec+0x3ed>
    if(argc >= MAXARG)
80100ee8:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100eec:	0f 87 e0 01 00 00    	ja     801010d2 <exec+0x541>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ef2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100efc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eff:	01 d0                	add    %edx,%eax
80100f01:	8b 00                	mov    (%eax),%eax
80100f03:	83 ec 0c             	sub    $0xc,%esp
80100f06:	50                   	push   %eax
80100f07:	e8 8e 48 00 00       	call   8010579a <strlen>
80100f0c:	83 c4 10             	add    $0x10,%esp
80100f0f:	89 c2                	mov    %eax,%edx
80100f11:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f14:	29 d0                	sub    %edx,%eax
80100f16:	83 e8 01             	sub    $0x1,%eax
80100f19:	83 e0 fc             	and    $0xfffffffc,%eax
80100f1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f29:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f2c:	01 d0                	add    %edx,%eax
80100f2e:	8b 00                	mov    (%eax),%eax
80100f30:	83 ec 0c             	sub    $0xc,%esp
80100f33:	50                   	push   %eax
80100f34:	e8 61 48 00 00       	call   8010579a <strlen>
80100f39:	83 c4 10             	add    $0x10,%esp
80100f3c:	83 c0 01             	add    $0x1,%eax
80100f3f:	89 c1                	mov    %eax,%ecx
80100f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f44:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f4e:	01 d0                	add    %edx,%eax
80100f50:	8b 00                	mov    (%eax),%eax
80100f52:	51                   	push   %ecx
80100f53:	50                   	push   %eax
80100f54:	ff 75 dc             	pushl  -0x24(%ebp)
80100f57:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f5a:	e8 99 7d 00 00       	call   80108cf8 <copyout>
80100f5f:	83 c4 10             	add    $0x10,%esp
80100f62:	85 c0                	test   %eax,%eax
80100f64:	0f 88 6b 01 00 00    	js     801010d5 <exec+0x544>
      goto bad;
    ustack[3+argc] = sp;
80100f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f6d:	8d 50 03             	lea    0x3(%eax),%edx
80100f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f73:	89 84 95 20 ff ff ff 	mov    %eax,-0xe0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f7a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100f7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f8b:	01 d0                	add    %edx,%eax
80100f8d:	8b 00                	mov    (%eax),%eax
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	0f 85 51 ff ff ff    	jne    80100ee8 <exec+0x357>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f9a:	83 c0 03             	add    $0x3,%eax
80100f9d:	c7 84 85 20 ff ff ff 	movl   $0x0,-0xe0(%ebp,%eax,4)
80100fa4:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100fa8:	c7 85 20 ff ff ff ff 	movl   $0xffffffff,-0xe0(%ebp)
80100faf:	ff ff ff 
  ustack[1] = argc;
80100fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fb5:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fbe:	83 c0 01             	add    $0x1,%eax
80100fc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100fc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100fcb:	29 d0                	sub    %edx,%eax
80100fcd:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)

  sp -= (3+argc+1) * 4;
80100fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fd6:	83 c0 04             	add    $0x4,%eax
80100fd9:	c1 e0 02             	shl    $0x2,%eax
80100fdc:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fe2:	83 c0 04             	add    $0x4,%eax
80100fe5:	c1 e0 02             	shl    $0x2,%eax
80100fe8:	50                   	push   %eax
80100fe9:	8d 85 20 ff ff ff    	lea    -0xe0(%ebp),%eax
80100fef:	50                   	push   %eax
80100ff0:	ff 75 dc             	pushl  -0x24(%ebp)
80100ff3:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ff6:	e8 fd 7c 00 00       	call   80108cf8 <copyout>
80100ffb:	83 c4 10             	add    $0x10,%esp
80100ffe:	85 c0                	test   %eax,%eax
80101000:	0f 88 d2 00 00 00    	js     801010d8 <exec+0x547>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101006:	8b 45 08             	mov    0x8(%ebp),%eax
80101009:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010100c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101012:	eb 17                	jmp    8010102b <exec+0x49a>
    if(*s == '/')
80101014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101017:	0f b6 00             	movzbl (%eax),%eax
8010101a:	3c 2f                	cmp    $0x2f,%al
8010101c:	75 09                	jne    80101027 <exec+0x496>
      last = s+1;
8010101e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101021:	83 c0 01             	add    $0x1,%eax
80101024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101027:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010102e:	0f b6 00             	movzbl (%eax),%eax
80101031:	84 c0                	test   %al,%al
80101033:	75 df                	jne    80101014 <exec+0x483>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80101035:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010103b:	83 c0 6c             	add    $0x6c,%eax
8010103e:	83 ec 04             	sub    $0x4,%esp
80101041:	6a 10                	push   $0x10
80101043:	ff 75 f0             	pushl  -0x10(%ebp)
80101046:	50                   	push   %eax
80101047:	e8 04 47 00 00       	call   80105750 <safestrcpy>
8010104c:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
8010104f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101055:	8b 40 04             	mov    0x4(%eax),%eax
80101058:	89 45 b0             	mov    %eax,-0x50(%ebp)
  proc->pgdir = pgdir;
8010105b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101061:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80101064:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80101067:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010106d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101070:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80101072:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101078:	8b 40 18             	mov    0x18(%eax),%eax
8010107b:	8b 95 04 ff ff ff    	mov    -0xfc(%ebp),%edx
80101081:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80101084:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010108a:	8b 40 18             	mov    0x18(%eax),%eax
8010108d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101090:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80101093:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101099:	83 ec 0c             	sub    $0xc,%esp
8010109c:	50                   	push   %eax
8010109d:	e8 b9 75 00 00       	call   8010865b <switchuvm>
801010a2:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
801010a5:	83 ec 0c             	sub    $0xc,%esp
801010a8:	ff 75 b0             	pushl  -0x50(%ebp)
801010ab:	e8 f1 79 00 00       	call   80108aa1 <freevm>
801010b0:	83 c4 10             	add    $0x10,%esp
  return 0;
801010b3:	b8 00 00 00 00       	mov    $0x0,%eax
801010b8:	eb 51                	jmp    8010110b <exec+0x57a>
    }


  // Check ELF header 
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf)) {
    goto bad;
801010ba:	90                   	nop
801010bb:	eb 1c                	jmp    801010d9 <exec+0x548>
  }
  if(elf.magic != ELF_MAGIC) {
    goto bad;
801010bd:	90                   	nop
801010be:	eb 19                	jmp    801010d9 <exec+0x548>
  }
  if((pgdir = setupkvm()) == 0) {
    goto bad;
801010c0:	90                   	nop
801010c1:	eb 16                	jmp    801010d9 <exec+0x548>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
801010c3:	90                   	nop
801010c4:	eb 13                	jmp    801010d9 <exec+0x548>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
801010c6:	90                   	nop
801010c7:	eb 10                	jmp    801010d9 <exec+0x548>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
801010c9:	90                   	nop
801010ca:	eb 0d                	jmp    801010d9 <exec+0x548>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
801010cc:	90                   	nop
801010cd:	eb 0a                	jmp    801010d9 <exec+0x548>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
801010cf:	90                   	nop
801010d0:	eb 07                	jmp    801010d9 <exec+0x548>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
801010d2:	90                   	nop
801010d3:	eb 04                	jmp    801010d9 <exec+0x548>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
801010d5:	90                   	nop
801010d6:	eb 01                	jmp    801010d9 <exec+0x548>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
801010d8:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
801010d9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
801010dd:	74 0e                	je     801010ed <exec+0x55c>
    freevm(pgdir);
801010df:	83 ec 0c             	sub    $0xc,%esp
801010e2:	ff 75 d4             	pushl  -0x2c(%ebp)
801010e5:	e8 b7 79 00 00       	call   80108aa1 <freevm>
801010ea:	83 c4 10             	add    $0x10,%esp
  if(ip){
801010ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801010f1:	74 13                	je     80101106 <exec+0x575>
    iunlockput(ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 75 d8             	pushl  -0x28(%ebp)
801010f9:	e8 02 0e 00 00       	call   80101f00 <iunlockput>
801010fe:	83 c4 10             	add    $0x10,%esp
    end_op();
80101101:	e8 a9 27 00 00       	call   801038af <end_op>
  }
  return -1;
80101106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010110b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010110e:	c9                   	leave  
8010110f:	c3                   	ret    

80101110 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80101116:	83 ec 08             	sub    $0x8,%esp
80101119:	68 f8 8d 10 80       	push   $0x80108df8
8010111e:	68 a0 19 11 80       	push   $0x801119a0
80101123:	e8 a0 41 00 00       	call   801052c8 <initlock>
80101128:	83 c4 10             	add    $0x10,%esp
}
8010112b:	90                   	nop
8010112c:	c9                   	leave  
8010112d:	c3                   	ret    

8010112e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
8010112e:	55                   	push   %ebp
8010112f:	89 e5                	mov    %esp,%ebp
80101131:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80101134:	83 ec 0c             	sub    $0xc,%esp
80101137:	68 a0 19 11 80       	push   $0x801119a0
8010113c:	e8 a9 41 00 00       	call   801052ea <acquire>
80101141:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101144:	c7 45 f4 d4 19 11 80 	movl   $0x801119d4,-0xc(%ebp)
8010114b:	eb 2d                	jmp    8010117a <filealloc+0x4c>
    if(f->ref == 0){
8010114d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101150:	8b 40 04             	mov    0x4(%eax),%eax
80101153:	85 c0                	test   %eax,%eax
80101155:	75 1f                	jne    80101176 <filealloc+0x48>
      f->ref = 1;
80101157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010115a:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101161:	83 ec 0c             	sub    $0xc,%esp
80101164:	68 a0 19 11 80       	push   $0x801119a0
80101169:	e8 e3 41 00 00       	call   80105351 <release>
8010116e:	83 c4 10             	add    $0x10,%esp
      return f;
80101171:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101174:	eb 23                	jmp    80101199 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101176:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010117a:	b8 34 23 11 80       	mov    $0x80112334,%eax
8010117f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101182:	72 c9                	jb     8010114d <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 a0 19 11 80       	push   $0x801119a0
8010118c:	e8 c0 41 00 00       	call   80105351 <release>
80101191:	83 c4 10             	add    $0x10,%esp
  return 0;
80101194:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101199:	c9                   	leave  
8010119a:	c3                   	ret    

8010119b <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010119b:	55                   	push   %ebp
8010119c:	89 e5                	mov    %esp,%ebp
8010119e:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801011a1:	83 ec 0c             	sub    $0xc,%esp
801011a4:	68 a0 19 11 80       	push   $0x801119a0
801011a9:	e8 3c 41 00 00       	call   801052ea <acquire>
801011ae:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011b1:	8b 45 08             	mov    0x8(%ebp),%eax
801011b4:	8b 40 04             	mov    0x4(%eax),%eax
801011b7:	85 c0                	test   %eax,%eax
801011b9:	7f 0d                	jg     801011c8 <filedup+0x2d>
    panic("filedup");
801011bb:	83 ec 0c             	sub    $0xc,%esp
801011be:	68 ff 8d 10 80       	push   $0x80108dff
801011c3:	e8 9e f3 ff ff       	call   80100566 <panic>
  f->ref++;
801011c8:	8b 45 08             	mov    0x8(%ebp),%eax
801011cb:	8b 40 04             	mov    0x4(%eax),%eax
801011ce:	8d 50 01             	lea    0x1(%eax),%edx
801011d1:	8b 45 08             	mov    0x8(%ebp),%eax
801011d4:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801011d7:	83 ec 0c             	sub    $0xc,%esp
801011da:	68 a0 19 11 80       	push   $0x801119a0
801011df:	e8 6d 41 00 00       	call   80105351 <release>
801011e4:	83 c4 10             	add    $0x10,%esp
  return f;
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801011ea:	c9                   	leave  
801011eb:	c3                   	ret    

801011ec <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011ec:	55                   	push   %ebp
801011ed:	89 e5                	mov    %esp,%ebp
801011ef:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801011f2:	83 ec 0c             	sub    $0xc,%esp
801011f5:	68 a0 19 11 80       	push   $0x801119a0
801011fa:	e8 eb 40 00 00       	call   801052ea <acquire>
801011ff:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101202:	8b 45 08             	mov    0x8(%ebp),%eax
80101205:	8b 40 04             	mov    0x4(%eax),%eax
80101208:	85 c0                	test   %eax,%eax
8010120a:	7f 0d                	jg     80101219 <fileclose+0x2d>
    panic("fileclose");
8010120c:	83 ec 0c             	sub    $0xc,%esp
8010120f:	68 07 8e 10 80       	push   $0x80108e07
80101214:	e8 4d f3 ff ff       	call   80100566 <panic>

////////////////////////////////////////////////////
if(f->type == FD_FIFO) {
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	8b 00                	mov    (%eax),%eax
8010121e:	83 f8 03             	cmp    $0x3,%eax
80101221:	0f 85 0f 01 00 00    	jne    80101336 <fileclose+0x14a>
    struct pipe * p = f->pipe;
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	8b 40 0c             	mov    0xc(%eax),%eax
8010122d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    acquire(&p->lock);
80101230:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101233:	83 ec 0c             	sub    $0xc,%esp
80101236:	50                   	push   %eax
80101237:	e8 ae 40 00 00       	call   801052ea <acquire>
8010123c:	83 c4 10             	add    $0x10,%esp
    if (f->readable) {
8010123f:	8b 45 08             	mov    0x8(%ebp),%eax
80101242:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101246:	84 c0                	test   %al,%al
80101248:	74 2b                	je     80101275 <fileclose+0x89>
      --p->readopen;
8010124a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010124d:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80101253:	8d 50 ff             	lea    -0x1(%eax),%edx
80101256:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101259:	89 90 3c 02 00 00    	mov    %edx,0x23c(%eax)
      wakeup(&p->nwrite);
8010125f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101262:	05 38 02 00 00       	add    $0x238,%eax
80101267:	83 ec 0c             	sub    $0xc,%esp
8010126a:	50                   	push   %eax
8010126b:	e8 66 3e 00 00       	call   801050d6 <wakeup>
80101270:	83 c4 10             	add    $0x10,%esp
80101273:	eb 34                	jmp    801012a9 <fileclose+0xbd>
    } else if (f->writable) {
80101275:	8b 45 08             	mov    0x8(%ebp),%eax
80101278:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010127c:	84 c0                	test   %al,%al
8010127e:	74 29                	je     801012a9 <fileclose+0xbd>
      --p->writeopen;
80101280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101283:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80101289:	8d 50 ff             	lea    -0x1(%eax),%edx
8010128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010128f:	89 90 40 02 00 00    	mov    %edx,0x240(%eax)
      wakeup(&p->nread);
80101295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101298:	05 34 02 00 00       	add    $0x234,%eax
8010129d:	83 ec 0c             	sub    $0xc,%esp
801012a0:	50                   	push   %eax
801012a1:	e8 30 3e 00 00       	call   801050d6 <wakeup>
801012a6:	83 c4 10             	add    $0x10,%esp
    }
    if (p->readopen == 0 && p->writeopen == 0) {
801012a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ac:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801012b2:	85 c0                	test   %eax,%eax
801012b4:	75 71                	jne    80101327 <fileclose+0x13b>
801012b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b9:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801012bf:	85 c0                	test   %eax,%eax
801012c1:	75 64                	jne    80101327 <fileclose+0x13b>
      release(&p->lock);
801012c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c6:	83 ec 0c             	sub    $0xc,%esp
801012c9:	50                   	push   %eax
801012ca:	e8 82 40 00 00       	call   80105351 <release>
801012cf:	83 c4 10             	add    $0x10,%esp
      pipeclose(p, f->writable);
801012d2:	8b 45 08             	mov    0x8(%ebp),%eax
801012d5:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012d9:	0f be c0             	movsbl %al,%eax
801012dc:	83 ec 08             	sub    $0x8,%esp
801012df:	50                   	push   %eax
801012e0:	ff 75 f4             	pushl  -0xc(%ebp)
801012e3:	e8 82 31 00 00       	call   8010446a <pipeclose>
801012e8:	83 c4 10             	add    $0x10,%esp
      f->ip->rf->ref = 0;
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 40 10             	mov    0x10(%eax),%eax
801012f1:	8b 40 10             	mov    0x10(%eax),%eax
801012f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      f->ip->rf = 0;
801012fb:	8b 45 08             	mov    0x8(%ebp),%eax
801012fe:	8b 40 10             	mov    0x10(%eax),%eax
80101301:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
      f->ip->wf->ref = 0;
80101308:	8b 45 08             	mov    0x8(%ebp),%eax
8010130b:	8b 40 10             	mov    0x10(%eax),%eax
8010130e:	8b 40 14             	mov    0x14(%eax),%eax
80101311:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      f->ip->wf = 0;
80101318:	8b 45 08             	mov    0x8(%ebp),%eax
8010131b:	8b 40 10             	mov    0x10(%eax),%eax
8010131e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
80101325:	eb 0f                	jmp    80101336 <fileclose+0x14a>
    } else {
      release(&p->lock);
80101327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010132a:	83 ec 0c             	sub    $0xc,%esp
8010132d:	50                   	push   %eax
8010132e:	e8 1e 40 00 00       	call   80105351 <release>
80101333:	83 c4 10             	add    $0x10,%esp
    }
  }
////////////////////////////////////////////////////

  if(--f->ref > 0){
80101336:	8b 45 08             	mov    0x8(%ebp),%eax
80101339:	8b 40 04             	mov    0x4(%eax),%eax
8010133c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010133f:	8b 45 08             	mov    0x8(%ebp),%eax
80101342:	89 50 04             	mov    %edx,0x4(%eax)
80101345:	8b 45 08             	mov    0x8(%ebp),%eax
80101348:	8b 40 04             	mov    0x4(%eax),%eax
8010134b:	85 c0                	test   %eax,%eax
8010134d:	7e 15                	jle    80101364 <fileclose+0x178>
    release(&ftable.lock);
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 a0 19 11 80       	push   $0x801119a0
80101357:	e8 f5 3f 00 00       	call   80105351 <release>
8010135c:	83 c4 10             	add    $0x10,%esp
8010135f:	e9 8b 00 00 00       	jmp    801013ef <fileclose+0x203>
    return;
  }
  
  ff = *f;
80101364:	8b 45 08             	mov    0x8(%ebp),%eax
80101367:	8b 10                	mov    (%eax),%edx
80101369:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010136c:	8b 50 04             	mov    0x4(%eax),%edx
8010136f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101372:	8b 50 08             	mov    0x8(%eax),%edx
80101375:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101378:	8b 50 0c             	mov    0xc(%eax),%edx
8010137b:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010137e:	8b 50 10             	mov    0x10(%eax),%edx
80101381:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101384:	8b 40 14             	mov    0x14(%eax),%eax
80101387:	89 45 f0             	mov    %eax,-0x10(%ebp)
  f->ref = 0;
8010138a:	8b 45 08             	mov    0x8(%ebp),%eax
8010138d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101394:	8b 45 08             	mov    0x8(%ebp),%eax
80101397:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010139d:	83 ec 0c             	sub    $0xc,%esp
801013a0:	68 a0 19 11 80       	push   $0x801119a0
801013a5:	e8 a7 3f 00 00       	call   80105351 <release>
801013aa:	83 c4 10             	add    $0x10,%esp


  if(ff.type == FD_PIPE) {
801013ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013b0:	83 f8 01             	cmp    $0x1,%eax
801013b3:	75 19                	jne    801013ce <fileclose+0x1e2>
    pipeclose(ff.pipe, ff.writable);
801013b5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
801013b9:	0f be d0             	movsbl %al,%edx
801013bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013bf:	83 ec 08             	sub    $0x8,%esp
801013c2:	52                   	push   %edx
801013c3:	50                   	push   %eax
801013c4:	e8 a1 30 00 00       	call   8010446a <pipeclose>
801013c9:	83 c4 10             	add    $0x10,%esp
801013cc:	eb 21                	jmp    801013ef <fileclose+0x203>
    }
  else if(ff.type == FD_INODE){
801013ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013d1:	83 f8 02             	cmp    $0x2,%eax
801013d4:	75 19                	jne    801013ef <fileclose+0x203>
    begin_op();
801013d6:	e8 48 24 00 00       	call   80103823 <begin_op>
    iput(ff.ip);
801013db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801013de:	83 ec 0c             	sub    $0xc,%esp
801013e1:	50                   	push   %eax
801013e2:	e8 29 0a 00 00       	call   80101e10 <iput>
801013e7:	83 c4 10             	add    $0x10,%esp
    end_op();
801013ea:	e8 c0 24 00 00       	call   801038af <end_op>
  }
}
801013ef:	c9                   	leave  
801013f0:	c3                   	ret    

801013f1 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801013f1:	55                   	push   %ebp
801013f2:	89 e5                	mov    %esp,%ebp
801013f4:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE || f->type == FD_FIFO){
801013f7:	8b 45 08             	mov    0x8(%ebp),%eax
801013fa:	8b 00                	mov    (%eax),%eax
801013fc:	83 f8 02             	cmp    $0x2,%eax
801013ff:	74 0a                	je     8010140b <filestat+0x1a>
80101401:	8b 45 08             	mov    0x8(%ebp),%eax
80101404:	8b 00                	mov    (%eax),%eax
80101406:	83 f8 03             	cmp    $0x3,%eax
80101409:	75 40                	jne    8010144b <filestat+0x5a>
    ilock(f->ip);
8010140b:	8b 45 08             	mov    0x8(%ebp),%eax
8010140e:	8b 40 10             	mov    0x10(%eax),%eax
80101411:	83 ec 0c             	sub    $0xc,%esp
80101414:	50                   	push   %eax
80101415:	e8 26 08 00 00       	call   80101c40 <ilock>
8010141a:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010141d:	8b 45 08             	mov    0x8(%ebp),%eax
80101420:	8b 40 10             	mov    0x10(%eax),%eax
80101423:	83 ec 08             	sub    $0x8,%esp
80101426:	ff 75 0c             	pushl  0xc(%ebp)
80101429:	50                   	push   %eax
8010142a:	e8 39 0d 00 00       	call   80102168 <stati>
8010142f:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101432:	8b 45 08             	mov    0x8(%ebp),%eax
80101435:	8b 40 10             	mov    0x10(%eax),%eax
80101438:	83 ec 0c             	sub    $0xc,%esp
8010143b:	50                   	push   %eax
8010143c:	e8 5d 09 00 00       	call   80101d9e <iunlock>
80101441:	83 c4 10             	add    $0x10,%esp
    return 0;
80101444:	b8 00 00 00 00       	mov    $0x0,%eax
80101449:	eb 05                	jmp    80101450 <filestat+0x5f>
  }
  return -1;
8010144b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101450:	c9                   	leave  
80101451:	c3                   	ret    

80101452 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101452:	55                   	push   %ebp
80101453:	89 e5                	mov    %esp,%ebp
80101455:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101458:	8b 45 08             	mov    0x8(%ebp),%eax
8010145b:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010145f:	84 c0                	test   %al,%al
80101461:	75 0a                	jne    8010146d <fileread+0x1b>
    return -1;
80101463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101468:	e9 a5 00 00 00       	jmp    80101512 <fileread+0xc0>
  if(f->type == FD_PIPE || f->type == FD_FIFO)
8010146d:	8b 45 08             	mov    0x8(%ebp),%eax
80101470:	8b 00                	mov    (%eax),%eax
80101472:	83 f8 01             	cmp    $0x1,%eax
80101475:	74 0a                	je     80101481 <fileread+0x2f>
80101477:	8b 45 08             	mov    0x8(%ebp),%eax
8010147a:	8b 00                	mov    (%eax),%eax
8010147c:	83 f8 03             	cmp    $0x3,%eax
8010147f:	75 1a                	jne    8010149b <fileread+0x49>
    return piperead(f->pipe, addr, n);
80101481:	8b 45 08             	mov    0x8(%ebp),%eax
80101484:	8b 40 0c             	mov    0xc(%eax),%eax
80101487:	83 ec 04             	sub    $0x4,%esp
8010148a:	ff 75 10             	pushl  0x10(%ebp)
8010148d:	ff 75 0c             	pushl  0xc(%ebp)
80101490:	50                   	push   %eax
80101491:	e8 7c 31 00 00       	call   80104612 <piperead>
80101496:	83 c4 10             	add    $0x10,%esp
80101499:	eb 77                	jmp    80101512 <fileread+0xc0>
  if(f->type == FD_INODE){
8010149b:	8b 45 08             	mov    0x8(%ebp),%eax
8010149e:	8b 00                	mov    (%eax),%eax
801014a0:	83 f8 02             	cmp    $0x2,%eax
801014a3:	75 60                	jne    80101505 <fileread+0xb3>
    ilock(f->ip);
801014a5:	8b 45 08             	mov    0x8(%ebp),%eax
801014a8:	8b 40 10             	mov    0x10(%eax),%eax
801014ab:	83 ec 0c             	sub    $0xc,%esp
801014ae:	50                   	push   %eax
801014af:	e8 8c 07 00 00       	call   80101c40 <ilock>
801014b4:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801014b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801014ba:	8b 45 08             	mov    0x8(%ebp),%eax
801014bd:	8b 50 14             	mov    0x14(%eax),%edx
801014c0:	8b 45 08             	mov    0x8(%ebp),%eax
801014c3:	8b 40 10             	mov    0x10(%eax),%eax
801014c6:	51                   	push   %ecx
801014c7:	52                   	push   %edx
801014c8:	ff 75 0c             	pushl  0xc(%ebp)
801014cb:	50                   	push   %eax
801014cc:	e8 dd 0c 00 00       	call   801021ae <readi>
801014d1:	83 c4 10             	add    $0x10,%esp
801014d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801014d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801014db:	7e 11                	jle    801014ee <fileread+0x9c>
      f->off += r;
801014dd:	8b 45 08             	mov    0x8(%ebp),%eax
801014e0:	8b 50 14             	mov    0x14(%eax),%edx
801014e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014e6:	01 c2                	add    %eax,%edx
801014e8:	8b 45 08             	mov    0x8(%ebp),%eax
801014eb:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801014ee:	8b 45 08             	mov    0x8(%ebp),%eax
801014f1:	8b 40 10             	mov    0x10(%eax),%eax
801014f4:	83 ec 0c             	sub    $0xc,%esp
801014f7:	50                   	push   %eax
801014f8:	e8 a1 08 00 00       	call   80101d9e <iunlock>
801014fd:	83 c4 10             	add    $0x10,%esp
    return r;
80101500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101503:	eb 0d                	jmp    80101512 <fileread+0xc0>
  }
  panic("fileread");
80101505:	83 ec 0c             	sub    $0xc,%esp
80101508:	68 11 8e 10 80       	push   $0x80108e11
8010150d:	e8 54 f0 ff ff       	call   80100566 <panic>
}
80101512:	c9                   	leave  
80101513:	c3                   	ret    

80101514 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	53                   	push   %ebx
80101518:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0) {
8010151b:	8b 45 08             	mov    0x8(%ebp),%eax
8010151e:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101522:	84 c0                	test   %al,%al
80101524:	75 0a                	jne    80101530 <filewrite+0x1c>
    return -1;
80101526:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010152b:	e9 25 01 00 00       	jmp    80101655 <filewrite+0x141>
  }
  if(f->type == FD_PIPE || f->type == FD_FIFO)
80101530:	8b 45 08             	mov    0x8(%ebp),%eax
80101533:	8b 00                	mov    (%eax),%eax
80101535:	83 f8 01             	cmp    $0x1,%eax
80101538:	74 0a                	je     80101544 <filewrite+0x30>
8010153a:	8b 45 08             	mov    0x8(%ebp),%eax
8010153d:	8b 00                	mov    (%eax),%eax
8010153f:	83 f8 03             	cmp    $0x3,%eax
80101542:	75 1d                	jne    80101561 <filewrite+0x4d>
    return pipewrite(f->pipe, addr, n);
80101544:	8b 45 08             	mov    0x8(%ebp),%eax
80101547:	8b 40 0c             	mov    0xc(%eax),%eax
8010154a:	83 ec 04             	sub    $0x4,%esp
8010154d:	ff 75 10             	pushl  0x10(%ebp)
80101550:	ff 75 0c             	pushl  0xc(%ebp)
80101553:	50                   	push   %eax
80101554:	e8 bb 2f 00 00       	call   80104514 <pipewrite>
80101559:	83 c4 10             	add    $0x10,%esp
8010155c:	e9 f4 00 00 00       	jmp    80101655 <filewrite+0x141>
  if(f->type == FD_INODE){
80101561:	8b 45 08             	mov    0x8(%ebp),%eax
80101564:	8b 00                	mov    (%eax),%eax
80101566:	83 f8 02             	cmp    $0x2,%eax
80101569:	0f 85 d9 00 00 00    	jne    80101648 <filewrite+0x134>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010156f:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010157d:	e9 a3 00 00 00       	jmp    80101625 <filewrite+0x111>
      int n1 = n - i;
80101582:	8b 45 10             	mov    0x10(%ebp),%eax
80101585:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101588:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010158b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010158e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101591:	7e 06                	jle    80101599 <filewrite+0x85>
        n1 = max;
80101593:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101596:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101599:	e8 85 22 00 00       	call   80103823 <begin_op>
      ilock(f->ip);
8010159e:	8b 45 08             	mov    0x8(%ebp),%eax
801015a1:	8b 40 10             	mov    0x10(%eax),%eax
801015a4:	83 ec 0c             	sub    $0xc,%esp
801015a7:	50                   	push   %eax
801015a8:	e8 93 06 00 00       	call   80101c40 <ilock>
801015ad:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801015b0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801015b3:	8b 45 08             	mov    0x8(%ebp),%eax
801015b6:	8b 50 14             	mov    0x14(%eax),%edx
801015b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801015bf:	01 c3                	add    %eax,%ebx
801015c1:	8b 45 08             	mov    0x8(%ebp),%eax
801015c4:	8b 40 10             	mov    0x10(%eax),%eax
801015c7:	51                   	push   %ecx
801015c8:	52                   	push   %edx
801015c9:	53                   	push   %ebx
801015ca:	50                   	push   %eax
801015cb:	e8 35 0d 00 00       	call   80102305 <writei>
801015d0:	83 c4 10             	add    $0x10,%esp
801015d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
801015d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801015da:	7e 11                	jle    801015ed <filewrite+0xd9>
        f->off += r;
801015dc:	8b 45 08             	mov    0x8(%ebp),%eax
801015df:	8b 50 14             	mov    0x14(%eax),%edx
801015e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801015e5:	01 c2                	add    %eax,%edx
801015e7:	8b 45 08             	mov    0x8(%ebp),%eax
801015ea:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801015ed:	8b 45 08             	mov    0x8(%ebp),%eax
801015f0:	8b 40 10             	mov    0x10(%eax),%eax
801015f3:	83 ec 0c             	sub    $0xc,%esp
801015f6:	50                   	push   %eax
801015f7:	e8 a2 07 00 00       	call   80101d9e <iunlock>
801015fc:	83 c4 10             	add    $0x10,%esp
      end_op();
801015ff:	e8 ab 22 00 00       	call   801038af <end_op>

      if(r < 0)
80101604:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101608:	78 29                	js     80101633 <filewrite+0x11f>
        break;
      if(r != n1)
8010160a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010160d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101610:	74 0d                	je     8010161f <filewrite+0x10b>
        panic("short filewrite");
80101612:	83 ec 0c             	sub    $0xc,%esp
80101615:	68 1a 8e 10 80       	push   $0x80108e1a
8010161a:	e8 47 ef ff ff       	call   80100566 <panic>
      i += r;
8010161f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101622:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101628:	3b 45 10             	cmp    0x10(%ebp),%eax
8010162b:	0f 8c 51 ff ff ff    	jl     80101582 <filewrite+0x6e>
80101631:	eb 01                	jmp    80101634 <filewrite+0x120>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101633:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101637:	3b 45 10             	cmp    0x10(%ebp),%eax
8010163a:	75 05                	jne    80101641 <filewrite+0x12d>
8010163c:	8b 45 10             	mov    0x10(%ebp),%eax
8010163f:	eb 14                	jmp    80101655 <filewrite+0x141>
80101641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101646:	eb 0d                	jmp    80101655 <filewrite+0x141>
  }
  panic("filewrite");
80101648:	83 ec 0c             	sub    $0xc,%esp
8010164b:	68 2a 8e 10 80       	push   $0x80108e2a
80101650:	e8 11 ef ff ff       	call   80100566 <panic>
}
80101655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101658:	c9                   	leave  
80101659:	c3                   	ret    

8010165a <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010165a:	55                   	push   %ebp
8010165b:	89 e5                	mov    %esp,%ebp
8010165d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101660:	8b 45 08             	mov    0x8(%ebp),%eax
80101663:	83 ec 08             	sub    $0x8,%esp
80101666:	6a 01                	push   $0x1
80101668:	50                   	push   %eax
80101669:	e8 48 eb ff ff       	call   801001b6 <bread>
8010166e:	83 c4 10             	add    $0x10,%esp
80101671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101677:	83 c0 18             	add    $0x18,%eax
8010167a:	83 ec 04             	sub    $0x4,%esp
8010167d:	6a 1c                	push   $0x1c
8010167f:	50                   	push   %eax
80101680:	ff 75 0c             	pushl  0xc(%ebp)
80101683:	e8 84 3f 00 00       	call   8010560c <memmove>
80101688:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010168b:	83 ec 0c             	sub    $0xc,%esp
8010168e:	ff 75 f4             	pushl  -0xc(%ebp)
80101691:	e8 98 eb ff ff       	call   8010022e <brelse>
80101696:	83 c4 10             	add    $0x10,%esp
}
80101699:	90                   	nop
8010169a:	c9                   	leave  
8010169b:	c3                   	ret    

8010169c <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010169c:	55                   	push   %ebp
8010169d:	89 e5                	mov    %esp,%ebp
8010169f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801016a5:	8b 45 08             	mov    0x8(%ebp),%eax
801016a8:	83 ec 08             	sub    $0x8,%esp
801016ab:	52                   	push   %edx
801016ac:	50                   	push   %eax
801016ad:	e8 04 eb ff ff       	call   801001b6 <bread>
801016b2:	83 c4 10             	add    $0x10,%esp
801016b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016bb:	83 c0 18             	add    $0x18,%eax
801016be:	83 ec 04             	sub    $0x4,%esp
801016c1:	68 00 02 00 00       	push   $0x200
801016c6:	6a 00                	push   $0x0
801016c8:	50                   	push   %eax
801016c9:	e8 7f 3e 00 00       	call   8010554d <memset>
801016ce:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801016d1:	83 ec 0c             	sub    $0xc,%esp
801016d4:	ff 75 f4             	pushl  -0xc(%ebp)
801016d7:	e8 7f 23 00 00       	call   80103a5b <log_write>
801016dc:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016df:	83 ec 0c             	sub    $0xc,%esp
801016e2:	ff 75 f4             	pushl  -0xc(%ebp)
801016e5:	e8 44 eb ff ff       	call   8010022e <brelse>
801016ea:	83 c4 10             	add    $0x10,%esp
}
801016ed:	90                   	nop
801016ee:	c9                   	leave  
801016ef:	c3                   	ret    

801016f0 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801016f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801016fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101704:	e9 13 01 00 00       	jmp    8010181c <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010170c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101712:	85 c0                	test   %eax,%eax
80101714:	0f 48 c2             	cmovs  %edx,%eax
80101717:	c1 f8 0c             	sar    $0xc,%eax
8010171a:	89 c2                	mov    %eax,%edx
8010171c:	a1 b8 23 11 80       	mov    0x801123b8,%eax
80101721:	01 d0                	add    %edx,%eax
80101723:	83 ec 08             	sub    $0x8,%esp
80101726:	50                   	push   %eax
80101727:	ff 75 08             	pushl  0x8(%ebp)
8010172a:	e8 87 ea ff ff       	call   801001b6 <bread>
8010172f:	83 c4 10             	add    $0x10,%esp
80101732:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101735:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010173c:	e9 a6 00 00 00       	jmp    801017e7 <balloc+0xf7>
      m = 1 << (bi % 8);
80101741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101744:	99                   	cltd   
80101745:	c1 ea 1d             	shr    $0x1d,%edx
80101748:	01 d0                	add    %edx,%eax
8010174a:	83 e0 07             	and    $0x7,%eax
8010174d:	29 d0                	sub    %edx,%eax
8010174f:	ba 01 00 00 00       	mov    $0x1,%edx
80101754:	89 c1                	mov    %eax,%ecx
80101756:	d3 e2                	shl    %cl,%edx
80101758:	89 d0                	mov    %edx,%eax
8010175a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101760:	8d 50 07             	lea    0x7(%eax),%edx
80101763:	85 c0                	test   %eax,%eax
80101765:	0f 48 c2             	cmovs  %edx,%eax
80101768:	c1 f8 03             	sar    $0x3,%eax
8010176b:	89 c2                	mov    %eax,%edx
8010176d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101770:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101775:	0f b6 c0             	movzbl %al,%eax
80101778:	23 45 e8             	and    -0x18(%ebp),%eax
8010177b:	85 c0                	test   %eax,%eax
8010177d:	75 64                	jne    801017e3 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010177f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101782:	8d 50 07             	lea    0x7(%eax),%edx
80101785:	85 c0                	test   %eax,%eax
80101787:	0f 48 c2             	cmovs  %edx,%eax
8010178a:	c1 f8 03             	sar    $0x3,%eax
8010178d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101790:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101795:	89 d1                	mov    %edx,%ecx
80101797:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010179a:	09 ca                	or     %ecx,%edx
8010179c:	89 d1                	mov    %edx,%ecx
8010179e:	8b 55 ec             	mov    -0x14(%ebp),%edx
801017a1:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801017a5:	83 ec 0c             	sub    $0xc,%esp
801017a8:	ff 75 ec             	pushl  -0x14(%ebp)
801017ab:	e8 ab 22 00 00       	call   80103a5b <log_write>
801017b0:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801017b3:	83 ec 0c             	sub    $0xc,%esp
801017b6:	ff 75 ec             	pushl  -0x14(%ebp)
801017b9:	e8 70 ea ff ff       	call   8010022e <brelse>
801017be:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801017c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c7:	01 c2                	add    %eax,%edx
801017c9:	8b 45 08             	mov    0x8(%ebp),%eax
801017cc:	83 ec 08             	sub    $0x8,%esp
801017cf:	52                   	push   %edx
801017d0:	50                   	push   %eax
801017d1:	e8 c6 fe ff ff       	call   8010169c <bzero>
801017d6:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801017d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017df:	01 d0                	add    %edx,%eax
801017e1:	eb 57                	jmp    8010183a <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801017e3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801017e7:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801017ee:	7f 17                	jg     80101807 <balloc+0x117>
801017f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f6:	01 d0                	add    %edx,%eax
801017f8:	89 c2                	mov    %eax,%edx
801017fa:	a1 a0 23 11 80       	mov    0x801123a0,%eax
801017ff:	39 c2                	cmp    %eax,%edx
80101801:	0f 82 3a ff ff ff    	jb     80101741 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101807:	83 ec 0c             	sub    $0xc,%esp
8010180a:	ff 75 ec             	pushl  -0x14(%ebp)
8010180d:	e8 1c ea ff ff       	call   8010022e <brelse>
80101812:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101815:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010181c:	8b 15 a0 23 11 80    	mov    0x801123a0,%edx
80101822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101825:	39 c2                	cmp    %eax,%edx
80101827:	0f 87 dc fe ff ff    	ja     80101709 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010182d:	83 ec 0c             	sub    $0xc,%esp
80101830:	68 34 8e 10 80       	push   $0x80108e34
80101835:	e8 2c ed ff ff       	call   80100566 <panic>
}
8010183a:	c9                   	leave  
8010183b:	c3                   	ret    

8010183c <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010183c:	55                   	push   %ebp
8010183d:	89 e5                	mov    %esp,%ebp
8010183f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101842:	83 ec 08             	sub    $0x8,%esp
80101845:	68 a0 23 11 80       	push   $0x801123a0
8010184a:	ff 75 08             	pushl  0x8(%ebp)
8010184d:	e8 08 fe ff ff       	call   8010165a <readsb>
80101852:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101855:	8b 45 0c             	mov    0xc(%ebp),%eax
80101858:	c1 e8 0c             	shr    $0xc,%eax
8010185b:	89 c2                	mov    %eax,%edx
8010185d:	a1 b8 23 11 80       	mov    0x801123b8,%eax
80101862:	01 c2                	add    %eax,%edx
80101864:	8b 45 08             	mov    0x8(%ebp),%eax
80101867:	83 ec 08             	sub    $0x8,%esp
8010186a:	52                   	push   %edx
8010186b:	50                   	push   %eax
8010186c:	e8 45 e9 ff ff       	call   801001b6 <bread>
80101871:	83 c4 10             	add    $0x10,%esp
80101874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101877:	8b 45 0c             	mov    0xc(%ebp),%eax
8010187a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010187f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101882:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101885:	99                   	cltd   
80101886:	c1 ea 1d             	shr    $0x1d,%edx
80101889:	01 d0                	add    %edx,%eax
8010188b:	83 e0 07             	and    $0x7,%eax
8010188e:	29 d0                	sub    %edx,%eax
80101890:	ba 01 00 00 00       	mov    $0x1,%edx
80101895:	89 c1                	mov    %eax,%ecx
80101897:	d3 e2                	shl    %cl,%edx
80101899:	89 d0                	mov    %edx,%eax
8010189b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010189e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a1:	8d 50 07             	lea    0x7(%eax),%edx
801018a4:	85 c0                	test   %eax,%eax
801018a6:	0f 48 c2             	cmovs  %edx,%eax
801018a9:	c1 f8 03             	sar    $0x3,%eax
801018ac:	89 c2                	mov    %eax,%edx
801018ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b1:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801018b6:	0f b6 c0             	movzbl %al,%eax
801018b9:	23 45 ec             	and    -0x14(%ebp),%eax
801018bc:	85 c0                	test   %eax,%eax
801018be:	75 0d                	jne    801018cd <bfree+0x91>
    panic("freeing free block");
801018c0:	83 ec 0c             	sub    $0xc,%esp
801018c3:	68 4a 8e 10 80       	push   $0x80108e4a
801018c8:	e8 99 ec ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801018cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018d0:	8d 50 07             	lea    0x7(%eax),%edx
801018d3:	85 c0                	test   %eax,%eax
801018d5:	0f 48 c2             	cmovs  %edx,%eax
801018d8:	c1 f8 03             	sar    $0x3,%eax
801018db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801018de:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801018e3:	89 d1                	mov    %edx,%ecx
801018e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801018e8:	f7 d2                	not    %edx
801018ea:	21 ca                	and    %ecx,%edx
801018ec:	89 d1                	mov    %edx,%ecx
801018ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801018f1:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801018f5:	83 ec 0c             	sub    $0xc,%esp
801018f8:	ff 75 f4             	pushl  -0xc(%ebp)
801018fb:	e8 5b 21 00 00       	call   80103a5b <log_write>
80101900:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101903:	83 ec 0c             	sub    $0xc,%esp
80101906:	ff 75 f4             	pushl  -0xc(%ebp)
80101909:	e8 20 e9 ff ff       	call   8010022e <brelse>
8010190e:	83 c4 10             	add    $0x10,%esp
}
80101911:	90                   	nop
80101912:	c9                   	leave  
80101913:	c3                   	ret    

80101914 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101914:	55                   	push   %ebp
80101915:	89 e5                	mov    %esp,%ebp
80101917:	57                   	push   %edi
80101918:	56                   	push   %esi
80101919:	53                   	push   %ebx
8010191a:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
8010191d:	83 ec 08             	sub    $0x8,%esp
80101920:	68 5d 8e 10 80       	push   $0x80108e5d
80101925:	68 c0 23 11 80       	push   $0x801123c0
8010192a:	e8 99 39 00 00       	call   801052c8 <initlock>
8010192f:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101932:	83 ec 08             	sub    $0x8,%esp
80101935:	68 a0 23 11 80       	push   $0x801123a0
8010193a:	ff 75 08             	pushl  0x8(%ebp)
8010193d:	e8 18 fd ff ff       	call   8010165a <readsb>
80101942:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101945:	a1 b8 23 11 80       	mov    0x801123b8,%eax
8010194a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010194d:	8b 3d b4 23 11 80    	mov    0x801123b4,%edi
80101953:	8b 35 b0 23 11 80    	mov    0x801123b0,%esi
80101959:	8b 1d ac 23 11 80    	mov    0x801123ac,%ebx
8010195f:	8b 0d a8 23 11 80    	mov    0x801123a8,%ecx
80101965:	8b 15 a4 23 11 80    	mov    0x801123a4,%edx
8010196b:	a1 a0 23 11 80       	mov    0x801123a0,%eax
80101970:	ff 75 e4             	pushl  -0x1c(%ebp)
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	51                   	push   %ecx
80101977:	52                   	push   %edx
80101978:	50                   	push   %eax
80101979:	68 64 8e 10 80       	push   $0x80108e64
8010197e:	e8 43 ea ff ff       	call   801003c6 <cprintf>
80101983:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101986:	90                   	nop
80101987:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010198a:	5b                   	pop    %ebx
8010198b:	5e                   	pop    %esi
8010198c:	5f                   	pop    %edi
8010198d:	5d                   	pop    %ebp
8010198e:	c3                   	ret    

8010198f <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010198f:	55                   	push   %ebp
80101990:	89 e5                	mov    %esp,%ebp
80101992:	83 ec 28             	sub    $0x28,%esp
80101995:	8b 45 0c             	mov    0xc(%ebp),%eax
80101998:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010199c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801019a3:	e9 9e 00 00 00       	jmp    80101a46 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ab:	c1 e8 03             	shr    $0x3,%eax
801019ae:	89 c2                	mov    %eax,%edx
801019b0:	a1 b4 23 11 80       	mov    0x801123b4,%eax
801019b5:	01 d0                	add    %edx,%eax
801019b7:	83 ec 08             	sub    $0x8,%esp
801019ba:	50                   	push   %eax
801019bb:	ff 75 08             	pushl  0x8(%ebp)
801019be:	e8 f3 e7 ff ff       	call   801001b6 <bread>
801019c3:	83 c4 10             	add    $0x10,%esp
801019c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801019c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019cc:	8d 50 18             	lea    0x18(%eax),%edx
801019cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019d2:	83 e0 07             	and    $0x7,%eax
801019d5:	c1 e0 06             	shl    $0x6,%eax
801019d8:	01 d0                	add    %edx,%eax
801019da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801019dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801019e0:	0f b7 00             	movzwl (%eax),%eax
801019e3:	66 85 c0             	test   %ax,%ax
801019e6:	75 4c                	jne    80101a34 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801019e8:	83 ec 04             	sub    $0x4,%esp
801019eb:	6a 40                	push   $0x40
801019ed:	6a 00                	push   $0x0
801019ef:	ff 75 ec             	pushl  -0x14(%ebp)
801019f2:	e8 56 3b 00 00       	call   8010554d <memset>
801019f7:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801019fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801019fd:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101a01:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101a04:	83 ec 0c             	sub    $0xc,%esp
80101a07:	ff 75 f0             	pushl  -0x10(%ebp)
80101a0a:	e8 4c 20 00 00       	call   80103a5b <log_write>
80101a0f:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101a12:	83 ec 0c             	sub    $0xc,%esp
80101a15:	ff 75 f0             	pushl  -0x10(%ebp)
80101a18:	e8 11 e8 ff ff       	call   8010022e <brelse>
80101a1d:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a23:	83 ec 08             	sub    $0x8,%esp
80101a26:	50                   	push   %eax
80101a27:	ff 75 08             	pushl  0x8(%ebp)
80101a2a:	e8 f8 00 00 00       	call   80101b27 <iget>
80101a2f:	83 c4 10             	add    $0x10,%esp
80101a32:	eb 30                	jmp    80101a64 <ialloc+0xd5>
    }
    brelse(bp);
80101a34:	83 ec 0c             	sub    $0xc,%esp
80101a37:	ff 75 f0             	pushl  -0x10(%ebp)
80101a3a:	e8 ef e7 ff ff       	call   8010022e <brelse>
80101a3f:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101a42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101a46:	8b 15 a8 23 11 80    	mov    0x801123a8,%edx
80101a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a4f:	39 c2                	cmp    %eax,%edx
80101a51:	0f 87 51 ff ff ff    	ja     801019a8 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101a57:	83 ec 0c             	sub    $0xc,%esp
80101a5a:	68 b7 8e 10 80       	push   $0x80108eb7
80101a5f:	e8 02 eb ff ff       	call   80100566 <panic>
}
80101a64:	c9                   	leave  
80101a65:	c3                   	ret    

80101a66 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101a66:	55                   	push   %ebp
80101a67:	89 e5                	mov    %esp,%ebp
80101a69:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6f:	8b 40 04             	mov    0x4(%eax),%eax
80101a72:	c1 e8 03             	shr    $0x3,%eax
80101a75:	89 c2                	mov    %eax,%edx
80101a77:	a1 b4 23 11 80       	mov    0x801123b4,%eax
80101a7c:	01 c2                	add    %eax,%edx
80101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a81:	8b 00                	mov    (%eax),%eax
80101a83:	83 ec 08             	sub    $0x8,%esp
80101a86:	52                   	push   %edx
80101a87:	50                   	push   %eax
80101a88:	e8 29 e7 ff ff       	call   801001b6 <bread>
80101a8d:	83 c4 10             	add    $0x10,%esp
80101a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a96:	8d 50 18             	lea    0x18(%eax),%edx
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 40 04             	mov    0x4(%eax),%eax
80101a9f:	83 e0 07             	and    $0x7,%eax
80101aa2:	c1 e0 06             	shl    $0x6,%eax
80101aa5:	01 d0                	add    %edx,%eax
80101aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80101aad:	0f b7 50 18          	movzwl 0x18(%eax),%edx
80101ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab4:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aba:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
80101abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac1:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac8:	0f b7 50 1c          	movzwl 0x1c(%eax),%edx
80101acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101acf:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad6:	0f b7 50 1e          	movzwl 0x1e(%eax),%edx
80101ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101add:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	8b 50 20             	mov    0x20(%eax),%edx
80101ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aea:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101aed:	8b 45 08             	mov    0x8(%ebp),%eax
80101af0:	8d 50 24             	lea    0x24(%eax),%edx
80101af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af6:	83 c0 0c             	add    $0xc,%eax
80101af9:	83 ec 04             	sub    $0x4,%esp
80101afc:	6a 34                	push   $0x34
80101afe:	52                   	push   %edx
80101aff:	50                   	push   %eax
80101b00:	e8 07 3b 00 00       	call   8010560c <memmove>
80101b05:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101b08:	83 ec 0c             	sub    $0xc,%esp
80101b0b:	ff 75 f4             	pushl  -0xc(%ebp)
80101b0e:	e8 48 1f 00 00       	call   80103a5b <log_write>
80101b13:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101b16:	83 ec 0c             	sub    $0xc,%esp
80101b19:	ff 75 f4             	pushl  -0xc(%ebp)
80101b1c:	e8 0d e7 ff ff       	call   8010022e <brelse>
80101b21:	83 c4 10             	add    $0x10,%esp
}
80101b24:	90                   	nop
80101b25:	c9                   	leave  
80101b26:	c3                   	ret    

80101b27 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101b27:	55                   	push   %ebp
80101b28:	89 e5                	mov    %esp,%ebp
80101b2a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101b2d:	83 ec 0c             	sub    $0xc,%esp
80101b30:	68 c0 23 11 80       	push   $0x801123c0
80101b35:	e8 b0 37 00 00       	call   801052ea <acquire>
80101b3a:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101b3d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101b44:	c7 45 f4 f4 23 11 80 	movl   $0x801123f4,-0xc(%ebp)
80101b4b:	eb 5d                	jmp    80101baa <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b50:	8b 40 08             	mov    0x8(%eax),%eax
80101b53:	85 c0                	test   %eax,%eax
80101b55:	7e 39                	jle    80101b90 <iget+0x69>
80101b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b5a:	8b 00                	mov    (%eax),%eax
80101b5c:	3b 45 08             	cmp    0x8(%ebp),%eax
80101b5f:	75 2f                	jne    80101b90 <iget+0x69>
80101b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b64:	8b 40 04             	mov    0x4(%eax),%eax
80101b67:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101b6a:	75 24                	jne    80101b90 <iget+0x69>
      ip->ref++;
80101b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b6f:	8b 40 08             	mov    0x8(%eax),%eax
80101b72:	8d 50 01             	lea    0x1(%eax),%edx
80101b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b78:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
80101b7e:	68 c0 23 11 80       	push   $0x801123c0
80101b83:	e8 c9 37 00 00       	call   80105351 <release>
80101b88:	83 c4 10             	add    $0x10,%esp
      return ip;
80101b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b8e:	eb 74                	jmp    80101c04 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101b90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101b94:	75 10                	jne    80101ba6 <iget+0x7f>
80101b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b99:	8b 40 08             	mov    0x8(%eax),%eax
80101b9c:	85 c0                	test   %eax,%eax
80101b9e:	75 06                	jne    80101ba6 <iget+0x7f>
      empty = ip;
80101ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ba3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101ba6:	83 45 f4 58          	addl   $0x58,-0xc(%ebp)
80101baa:	81 7d f4 24 35 11 80 	cmpl   $0x80113524,-0xc(%ebp)
80101bb1:	72 9a                	jb     80101b4d <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101bb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101bb7:	75 0d                	jne    80101bc6 <iget+0x9f>
    panic("iget: no inodes");
80101bb9:	83 ec 0c             	sub    $0xc,%esp
80101bbc:	68 c9 8e 10 80       	push   $0x80108ec9
80101bc1:	e8 a0 e9 ff ff       	call   80100566 <panic>

  ip = empty;
80101bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bcf:	8b 55 08             	mov    0x8(%ebp),%edx
80101bd2:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bda:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101bf1:	83 ec 0c             	sub    $0xc,%esp
80101bf4:	68 c0 23 11 80       	push   $0x801123c0
80101bf9:	e8 53 37 00 00       	call   80105351 <release>
80101bfe:	83 c4 10             	add    $0x10,%esp

  return ip;
80101c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101c04:	c9                   	leave  
80101c05:	c3                   	ret    

80101c06 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101c06:	55                   	push   %ebp
80101c07:	89 e5                	mov    %esp,%ebp
80101c09:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101c0c:	83 ec 0c             	sub    $0xc,%esp
80101c0f:	68 c0 23 11 80       	push   $0x801123c0
80101c14:	e8 d1 36 00 00       	call   801052ea <acquire>
80101c19:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1f:	8b 40 08             	mov    0x8(%eax),%eax
80101c22:	8d 50 01             	lea    0x1(%eax),%edx
80101c25:	8b 45 08             	mov    0x8(%ebp),%eax
80101c28:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c2b:	83 ec 0c             	sub    $0xc,%esp
80101c2e:	68 c0 23 11 80       	push   $0x801123c0
80101c33:	e8 19 37 00 00       	call   80105351 <release>
80101c38:	83 c4 10             	add    $0x10,%esp
  return ip;
80101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101c3e:	c9                   	leave  
80101c3f:	c3                   	ret    

80101c40 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101c46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c4a:	74 0a                	je     80101c56 <ilock+0x16>
80101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4f:	8b 40 08             	mov    0x8(%eax),%eax
80101c52:	85 c0                	test   %eax,%eax
80101c54:	7f 0d                	jg     80101c63 <ilock+0x23>
    panic("ilock");
80101c56:	83 ec 0c             	sub    $0xc,%esp
80101c59:	68 d9 8e 10 80       	push   $0x80108ed9
80101c5e:	e8 03 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101c63:	83 ec 0c             	sub    $0xc,%esp
80101c66:	68 c0 23 11 80       	push   $0x801123c0
80101c6b:	e8 7a 36 00 00       	call   801052ea <acquire>
80101c70:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101c73:	eb 13                	jmp    80101c88 <ilock+0x48>
    sleep(ip, &icache.lock);
80101c75:	83 ec 08             	sub    $0x8,%esp
80101c78:	68 c0 23 11 80       	push   $0x801123c0
80101c7d:	ff 75 08             	pushl  0x8(%ebp)
80101c80:	e8 63 33 00 00       	call   80104fe8 <sleep>
80101c85:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101c88:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8b:	8b 40 0c             	mov    0xc(%eax),%eax
80101c8e:	83 e0 01             	and    $0x1,%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	75 e0                	jne    80101c75 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101c95:	8b 45 08             	mov    0x8(%ebp),%eax
80101c98:	8b 40 0c             	mov    0xc(%eax),%eax
80101c9b:	83 c8 01             	or     $0x1,%eax
80101c9e:	89 c2                	mov    %eax,%edx
80101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca3:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101ca6:	83 ec 0c             	sub    $0xc,%esp
80101ca9:	68 c0 23 11 80       	push   $0x801123c0
80101cae:	e8 9e 36 00 00       	call   80105351 <release>
80101cb3:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb9:	8b 40 0c             	mov    0xc(%eax),%eax
80101cbc:	83 e0 02             	and    $0x2,%eax
80101cbf:	85 c0                	test   %eax,%eax
80101cc1:	0f 85 d4 00 00 00    	jne    80101d9b <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cca:	8b 40 04             	mov    0x4(%eax),%eax
80101ccd:	c1 e8 03             	shr    $0x3,%eax
80101cd0:	89 c2                	mov    %eax,%edx
80101cd2:	a1 b4 23 11 80       	mov    0x801123b4,%eax
80101cd7:	01 c2                	add    %eax,%edx
80101cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdc:	8b 00                	mov    (%eax),%eax
80101cde:	83 ec 08             	sub    $0x8,%esp
80101ce1:	52                   	push   %edx
80101ce2:	50                   	push   %eax
80101ce3:	e8 ce e4 ff ff       	call   801001b6 <bread>
80101ce8:	83 c4 10             	add    $0x10,%esp
80101ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cf1:	8d 50 18             	lea    0x18(%eax),%edx
80101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf7:	8b 40 04             	mov    0x4(%eax),%eax
80101cfa:	83 e0 07             	and    $0x7,%eax
80101cfd:	c1 e0 06             	shl    $0x6,%eax
80101d00:	01 d0                	add    %edx,%eax
80101d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d08:	0f b7 10             	movzwl (%eax),%edx
80101d0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0e:	66 89 50 18          	mov    %dx,0x18(%eax)
    ip->major = dip->major;
80101d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d15:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101d19:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1c:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    ip->minor = dip->minor;
80101d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d23:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101d27:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2a:	66 89 50 1c          	mov    %dx,0x1c(%eax)
    ip->nlink = dip->nlink;
80101d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d31:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101d35:	8b 45 08             	mov    0x8(%ebp),%eax
80101d38:	66 89 50 1e          	mov    %dx,0x1e(%eax)
    ip->size = dip->size;
80101d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d3f:	8b 50 08             	mov    0x8(%eax),%edx
80101d42:	8b 45 08             	mov    0x8(%ebp),%eax
80101d45:	89 50 20             	mov    %edx,0x20(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d4b:	8d 50 0c             	lea    0xc(%eax),%edx
80101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d51:	83 c0 24             	add    $0x24,%eax
80101d54:	83 ec 04             	sub    $0x4,%esp
80101d57:	6a 34                	push   $0x34
80101d59:	52                   	push   %edx
80101d5a:	50                   	push   %eax
80101d5b:	e8 ac 38 00 00       	call   8010560c <memmove>
80101d60:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101d63:	83 ec 0c             	sub    $0xc,%esp
80101d66:	ff 75 f4             	pushl  -0xc(%ebp)
80101d69:	e8 c0 e4 ff ff       	call   8010022e <brelse>
80101d6e:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101d71:	8b 45 08             	mov    0x8(%ebp),%eax
80101d74:	8b 40 0c             	mov    0xc(%eax),%eax
80101d77:	83 c8 02             	or     $0x2,%eax
80101d7a:	89 c2                	mov    %eax,%edx
80101d7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7f:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101d82:	8b 45 08             	mov    0x8(%ebp),%eax
80101d85:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80101d89:	66 85 c0             	test   %ax,%ax
80101d8c:	75 0d                	jne    80101d9b <ilock+0x15b>
      panic("ilock: no type");
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	68 df 8e 10 80       	push   $0x80108edf
80101d96:	e8 cb e7 ff ff       	call   80100566 <panic>
  }
}
80101d9b:	90                   	nop
80101d9c:	c9                   	leave  
80101d9d:	c3                   	ret    

80101d9e <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101d9e:	55                   	push   %ebp
80101d9f:	89 e5                	mov    %esp,%ebp
80101da1:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101da4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101da8:	74 17                	je     80101dc1 <iunlock+0x23>
80101daa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dad:	8b 40 0c             	mov    0xc(%eax),%eax
80101db0:	83 e0 01             	and    $0x1,%eax
80101db3:	85 c0                	test   %eax,%eax
80101db5:	74 0a                	je     80101dc1 <iunlock+0x23>
80101db7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dba:	8b 40 08             	mov    0x8(%eax),%eax
80101dbd:	85 c0                	test   %eax,%eax
80101dbf:	7f 0d                	jg     80101dce <iunlock+0x30>
    panic("iunlock");
80101dc1:	83 ec 0c             	sub    $0xc,%esp
80101dc4:	68 ee 8e 10 80       	push   $0x80108eee
80101dc9:	e8 98 e7 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101dce:	83 ec 0c             	sub    $0xc,%esp
80101dd1:	68 c0 23 11 80       	push   $0x801123c0
80101dd6:	e8 0f 35 00 00       	call   801052ea <acquire>
80101ddb:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101dde:	8b 45 08             	mov    0x8(%ebp),%eax
80101de1:	8b 40 0c             	mov    0xc(%eax),%eax
80101de4:	83 e0 fe             	and    $0xfffffffe,%eax
80101de7:	89 c2                	mov    %eax,%edx
80101de9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dec:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101def:	83 ec 0c             	sub    $0xc,%esp
80101df2:	ff 75 08             	pushl  0x8(%ebp)
80101df5:	e8 dc 32 00 00       	call   801050d6 <wakeup>
80101dfa:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101dfd:	83 ec 0c             	sub    $0xc,%esp
80101e00:	68 c0 23 11 80       	push   $0x801123c0
80101e05:	e8 47 35 00 00       	call   80105351 <release>
80101e0a:	83 c4 10             	add    $0x10,%esp
}
80101e0d:	90                   	nop
80101e0e:	c9                   	leave  
80101e0f:	c3                   	ret    

80101e10 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101e16:	83 ec 0c             	sub    $0xc,%esp
80101e19:	68 c0 23 11 80       	push   $0x801123c0
80101e1e:	e8 c7 34 00 00       	call   801052ea <acquire>
80101e23:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101e26:	8b 45 08             	mov    0x8(%ebp),%eax
80101e29:	8b 40 08             	mov    0x8(%eax),%eax
80101e2c:	83 f8 01             	cmp    $0x1,%eax
80101e2f:	0f 85 a9 00 00 00    	jne    80101ede <iput+0xce>
80101e35:	8b 45 08             	mov    0x8(%ebp),%eax
80101e38:	8b 40 0c             	mov    0xc(%eax),%eax
80101e3b:	83 e0 02             	and    $0x2,%eax
80101e3e:	85 c0                	test   %eax,%eax
80101e40:	0f 84 98 00 00 00    	je     80101ede <iput+0xce>
80101e46:	8b 45 08             	mov    0x8(%ebp),%eax
80101e49:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
80101e4d:	66 85 c0             	test   %ax,%ax
80101e50:	0f 85 88 00 00 00    	jne    80101ede <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101e56:	8b 45 08             	mov    0x8(%ebp),%eax
80101e59:	8b 40 0c             	mov    0xc(%eax),%eax
80101e5c:	83 e0 01             	and    $0x1,%eax
80101e5f:	85 c0                	test   %eax,%eax
80101e61:	74 0d                	je     80101e70 <iput+0x60>
      panic("iput busy");
80101e63:	83 ec 0c             	sub    $0xc,%esp
80101e66:	68 f6 8e 10 80       	push   $0x80108ef6
80101e6b:	e8 f6 e6 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101e70:	8b 45 08             	mov    0x8(%ebp),%eax
80101e73:	8b 40 0c             	mov    0xc(%eax),%eax
80101e76:	83 c8 01             	or     $0x1,%eax
80101e79:	89 c2                	mov    %eax,%edx
80101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7e:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101e81:	83 ec 0c             	sub    $0xc,%esp
80101e84:	68 c0 23 11 80       	push   $0x801123c0
80101e89:	e8 c3 34 00 00       	call   80105351 <release>
80101e8e:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101e91:	83 ec 0c             	sub    $0xc,%esp
80101e94:	ff 75 08             	pushl  0x8(%ebp)
80101e97:	e8 a8 01 00 00       	call   80102044 <itrunc>
80101e9c:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea2:	66 c7 40 18 00 00    	movw   $0x0,0x18(%eax)
    iupdate(ip);
80101ea8:	83 ec 0c             	sub    $0xc,%esp
80101eab:	ff 75 08             	pushl  0x8(%ebp)
80101eae:	e8 b3 fb ff ff       	call   80101a66 <iupdate>
80101eb3:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101eb6:	83 ec 0c             	sub    $0xc,%esp
80101eb9:	68 c0 23 11 80       	push   $0x801123c0
80101ebe:	e8 27 34 00 00       	call   801052ea <acquire>
80101ec3:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101ec6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ed0:	83 ec 0c             	sub    $0xc,%esp
80101ed3:	ff 75 08             	pushl  0x8(%ebp)
80101ed6:	e8 fb 31 00 00       	call   801050d6 <wakeup>
80101edb:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101ede:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee1:	8b 40 08             	mov    0x8(%eax),%eax
80101ee4:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ee7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eea:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101eed:	83 ec 0c             	sub    $0xc,%esp
80101ef0:	68 c0 23 11 80       	push   $0x801123c0
80101ef5:	e8 57 34 00 00       	call   80105351 <release>
80101efa:	83 c4 10             	add    $0x10,%esp
}
80101efd:	90                   	nop
80101efe:	c9                   	leave  
80101eff:	c3                   	ret    

80101f00 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101f06:	83 ec 0c             	sub    $0xc,%esp
80101f09:	ff 75 08             	pushl  0x8(%ebp)
80101f0c:	e8 8d fe ff ff       	call   80101d9e <iunlock>
80101f11:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101f14:	83 ec 0c             	sub    $0xc,%esp
80101f17:	ff 75 08             	pushl  0x8(%ebp)
80101f1a:	e8 f1 fe ff ff       	call   80101e10 <iput>
80101f1f:	83 c4 10             	add    $0x10,%esp
}
80101f22:	90                   	nop
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    

80101f25 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101f25:	55                   	push   %ebp
80101f26:	89 e5                	mov    %esp,%ebp
80101f28:	53                   	push   %ebx
80101f29:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101f2c:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101f30:	77 42                	ja     80101f74 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101f32:	8b 45 08             	mov    0x8(%ebp),%eax
80101f35:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f38:	83 c2 08             	add    $0x8,%edx
80101f3b:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101f42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101f46:	75 24                	jne    80101f6c <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	8b 00                	mov    (%eax),%eax
80101f4d:	83 ec 0c             	sub    $0xc,%esp
80101f50:	50                   	push   %eax
80101f51:	e8 9a f7 ff ff       	call   801016f0 <balloc>
80101f56:	83 c4 10             	add    $0x10,%esp
80101f59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f62:	8d 4a 08             	lea    0x8(%edx),%ecx
80101f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f68:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80101f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f6f:	e9 cb 00 00 00       	jmp    8010203f <bmap+0x11a>
  }
  bn -= NDIRECT;
80101f74:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101f78:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101f7c:	0f 87 b0 00 00 00    	ja     80102032 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101f82:	8b 45 08             	mov    0x8(%ebp),%eax
80101f85:	8b 40 54             	mov    0x54(%eax),%eax
80101f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101f8f:	75 1d                	jne    80101fae <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101f91:	8b 45 08             	mov    0x8(%ebp),%eax
80101f94:	8b 00                	mov    (%eax),%eax
80101f96:	83 ec 0c             	sub    $0xc,%esp
80101f99:	50                   	push   %eax
80101f9a:	e8 51 f7 ff ff       	call   801016f0 <balloc>
80101f9f:	83 c4 10             	add    $0x10,%esp
80101fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101fa5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101fab:	89 50 54             	mov    %edx,0x54(%eax)
    bp = bread(ip->dev, addr);
80101fae:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb1:	8b 00                	mov    (%eax),%eax
80101fb3:	83 ec 08             	sub    $0x8,%esp
80101fb6:	ff 75 f4             	pushl  -0xc(%ebp)
80101fb9:	50                   	push   %eax
80101fba:	e8 f7 e1 ff ff       	call   801001b6 <bread>
80101fbf:	83 c4 10             	add    $0x10,%esp
80101fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fc8:	83 c0 18             	add    $0x18,%eax
80101fcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101fce:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fdb:	01 d0                	add    %edx,%eax
80101fdd:	8b 00                	mov    (%eax),%eax
80101fdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101fe6:	75 37                	jne    8010201f <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101feb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ff5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffb:	8b 00                	mov    (%eax),%eax
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 ea f6 ff ff       	call   801016f0 <balloc>
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010200f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80102011:	83 ec 0c             	sub    $0xc,%esp
80102014:	ff 75 f0             	pushl  -0x10(%ebp)
80102017:	e8 3f 1a 00 00       	call   80103a5b <log_write>
8010201c:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
8010201f:	83 ec 0c             	sub    $0xc,%esp
80102022:	ff 75 f0             	pushl  -0x10(%ebp)
80102025:	e8 04 e2 ff ff       	call   8010022e <brelse>
8010202a:	83 c4 10             	add    $0x10,%esp
    return addr;
8010202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102030:	eb 0d                	jmp    8010203f <bmap+0x11a>
  }

  panic("bmap: out of range");
80102032:	83 ec 0c             	sub    $0xc,%esp
80102035:	68 00 8f 10 80       	push   $0x80108f00
8010203a:	e8 27 e5 ff ff       	call   80100566 <panic>
}
8010203f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102042:	c9                   	leave  
80102043:	c3                   	ret    

80102044 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80102044:	55                   	push   %ebp
80102045:	89 e5                	mov    %esp,%ebp
80102047:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
8010204a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102051:	eb 45                	jmp    80102098 <itrunc+0x54>
    if(ip->addrs[i]){
80102053:	8b 45 08             	mov    0x8(%ebp),%eax
80102056:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102059:	83 c2 08             	add    $0x8,%edx
8010205c:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102060:	85 c0                	test   %eax,%eax
80102062:	74 30                	je     80102094 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80102064:	8b 45 08             	mov    0x8(%ebp),%eax
80102067:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010206a:	83 c2 08             	add    $0x8,%edx
8010206d:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102071:	8b 55 08             	mov    0x8(%ebp),%edx
80102074:	8b 12                	mov    (%edx),%edx
80102076:	83 ec 08             	sub    $0x8,%esp
80102079:	50                   	push   %eax
8010207a:	52                   	push   %edx
8010207b:	e8 bc f7 ff ff       	call   8010183c <bfree>
80102080:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80102083:	8b 45 08             	mov    0x8(%ebp),%eax
80102086:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102089:	83 c2 08             	add    $0x8,%edx
8010208c:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
80102093:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102094:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102098:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
8010209c:	7e b5                	jle    80102053 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
8010209e:	8b 45 08             	mov    0x8(%ebp),%eax
801020a1:	8b 40 54             	mov    0x54(%eax),%eax
801020a4:	85 c0                	test   %eax,%eax
801020a6:	0f 84 a1 00 00 00    	je     8010214d <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801020ac:	8b 45 08             	mov    0x8(%ebp),%eax
801020af:	8b 50 54             	mov    0x54(%eax),%edx
801020b2:	8b 45 08             	mov    0x8(%ebp),%eax
801020b5:	8b 00                	mov    (%eax),%eax
801020b7:	83 ec 08             	sub    $0x8,%esp
801020ba:	52                   	push   %edx
801020bb:	50                   	push   %eax
801020bc:	e8 f5 e0 ff ff       	call   801001b6 <bread>
801020c1:	83 c4 10             	add    $0x10,%esp
801020c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
801020c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ca:	83 c0 18             	add    $0x18,%eax
801020cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801020d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801020d7:	eb 3c                	jmp    80102115 <itrunc+0xd1>
      if(a[j])
801020d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801020e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801020e6:	01 d0                	add    %edx,%eax
801020e8:	8b 00                	mov    (%eax),%eax
801020ea:	85 c0                	test   %eax,%eax
801020ec:	74 23                	je     80102111 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
801020ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801020f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801020fb:	01 d0                	add    %edx,%eax
801020fd:	8b 00                	mov    (%eax),%eax
801020ff:	8b 55 08             	mov    0x8(%ebp),%edx
80102102:	8b 12                	mov    (%edx),%edx
80102104:	83 ec 08             	sub    $0x8,%esp
80102107:	50                   	push   %eax
80102108:	52                   	push   %edx
80102109:	e8 2e f7 ff ff       	call   8010183c <bfree>
8010210e:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80102111:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80102115:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102118:	83 f8 7f             	cmp    $0x7f,%eax
8010211b:	76 bc                	jbe    801020d9 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
8010211d:	83 ec 0c             	sub    $0xc,%esp
80102120:	ff 75 ec             	pushl  -0x14(%ebp)
80102123:	e8 06 e1 ff ff       	call   8010022e <brelse>
80102128:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
8010212e:	8b 40 54             	mov    0x54(%eax),%eax
80102131:	8b 55 08             	mov    0x8(%ebp),%edx
80102134:	8b 12                	mov    (%edx),%edx
80102136:	83 ec 08             	sub    $0x8,%esp
80102139:	50                   	push   %eax
8010213a:	52                   	push   %edx
8010213b:	e8 fc f6 ff ff       	call   8010183c <bfree>
80102140:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80102143:	8b 45 08             	mov    0x8(%ebp),%eax
80102146:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
  }

  ip->size = 0;
8010214d:	8b 45 08             	mov    0x8(%ebp),%eax
80102150:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  iupdate(ip);
80102157:	83 ec 0c             	sub    $0xc,%esp
8010215a:	ff 75 08             	pushl  0x8(%ebp)
8010215d:	e8 04 f9 ff ff       	call   80101a66 <iupdate>
80102162:	83 c4 10             	add    $0x10,%esp
}
80102165:	90                   	nop
80102166:	c9                   	leave  
80102167:	c3                   	ret    

80102168 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80102168:	55                   	push   %ebp
80102169:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
8010216b:	8b 45 08             	mov    0x8(%ebp),%eax
8010216e:	8b 00                	mov    (%eax),%eax
80102170:	89 c2                	mov    %eax,%edx
80102172:	8b 45 0c             	mov    0xc(%ebp),%eax
80102175:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102178:	8b 45 08             	mov    0x8(%ebp),%eax
8010217b:	8b 50 04             	mov    0x4(%eax),%edx
8010217e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102181:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80102184:	8b 45 08             	mov    0x8(%ebp),%eax
80102187:	0f b7 50 18          	movzwl 0x18(%eax),%edx
8010218b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010218e:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80102191:	8b 45 08             	mov    0x8(%ebp),%eax
80102194:	0f b7 50 1e          	movzwl 0x1e(%eax),%edx
80102198:	8b 45 0c             	mov    0xc(%ebp),%eax
8010219b:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
8010219f:	8b 45 08             	mov    0x8(%ebp),%eax
801021a2:	8b 50 20             	mov    0x20(%eax),%edx
801021a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801021a8:	89 50 10             	mov    %edx,0x10(%eax)
}
801021ab:	90                   	nop
801021ac:	5d                   	pop    %ebp
801021ad:	c3                   	ret    

801021ae <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801021ae:	55                   	push   %ebp
801021af:	89 e5                	mov    %esp,%ebp
801021b1:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801021b4:	8b 45 08             	mov    0x8(%ebp),%eax
801021b7:	0f b7 40 18          	movzwl 0x18(%eax),%eax
801021bb:	66 83 f8 03          	cmp    $0x3,%ax
801021bf:	75 5c                	jne    8010221d <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801021c1:	8b 45 08             	mov    0x8(%ebp),%eax
801021c4:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
801021c8:	66 85 c0             	test   %ax,%ax
801021cb:	78 20                	js     801021ed <readi+0x3f>
801021cd:	8b 45 08             	mov    0x8(%ebp),%eax
801021d0:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
801021d4:	66 83 f8 09          	cmp    $0x9,%ax
801021d8:	7f 13                	jg     801021ed <readi+0x3f>
801021da:	8b 45 08             	mov    0x8(%ebp),%eax
801021dd:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
801021e1:	98                   	cwtl   
801021e2:	8b 04 c5 40 23 11 80 	mov    -0x7feedcc0(,%eax,8),%eax
801021e9:	85 c0                	test   %eax,%eax
801021eb:	75 0a                	jne    801021f7 <readi+0x49>
      return -1;
801021ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021f2:	e9 0c 01 00 00       	jmp    80102303 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
801021f7:	8b 45 08             	mov    0x8(%ebp),%eax
801021fa:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
801021fe:	98                   	cwtl   
801021ff:	8b 04 c5 40 23 11 80 	mov    -0x7feedcc0(,%eax,8),%eax
80102206:	8b 55 14             	mov    0x14(%ebp),%edx
80102209:	83 ec 04             	sub    $0x4,%esp
8010220c:	52                   	push   %edx
8010220d:	ff 75 0c             	pushl  0xc(%ebp)
80102210:	ff 75 08             	pushl  0x8(%ebp)
80102213:	ff d0                	call   *%eax
80102215:	83 c4 10             	add    $0x10,%esp
80102218:	e9 e6 00 00 00       	jmp    80102303 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
8010221d:	8b 45 08             	mov    0x8(%ebp),%eax
80102220:	8b 40 20             	mov    0x20(%eax),%eax
80102223:	3b 45 10             	cmp    0x10(%ebp),%eax
80102226:	72 0d                	jb     80102235 <readi+0x87>
80102228:	8b 55 10             	mov    0x10(%ebp),%edx
8010222b:	8b 45 14             	mov    0x14(%ebp),%eax
8010222e:	01 d0                	add    %edx,%eax
80102230:	3b 45 10             	cmp    0x10(%ebp),%eax
80102233:	73 0a                	jae    8010223f <readi+0x91>
    return -1;
80102235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010223a:	e9 c4 00 00 00       	jmp    80102303 <readi+0x155>
  if(off + n > ip->size)
8010223f:	8b 55 10             	mov    0x10(%ebp),%edx
80102242:	8b 45 14             	mov    0x14(%ebp),%eax
80102245:	01 c2                	add    %eax,%edx
80102247:	8b 45 08             	mov    0x8(%ebp),%eax
8010224a:	8b 40 20             	mov    0x20(%eax),%eax
8010224d:	39 c2                	cmp    %eax,%edx
8010224f:	76 0c                	jbe    8010225d <readi+0xaf>
    n = ip->size - off;
80102251:	8b 45 08             	mov    0x8(%ebp),%eax
80102254:	8b 40 20             	mov    0x20(%eax),%eax
80102257:	2b 45 10             	sub    0x10(%ebp),%eax
8010225a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010225d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102264:	e9 8b 00 00 00       	jmp    801022f4 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102269:	8b 45 10             	mov    0x10(%ebp),%eax
8010226c:	c1 e8 09             	shr    $0x9,%eax
8010226f:	83 ec 08             	sub    $0x8,%esp
80102272:	50                   	push   %eax
80102273:	ff 75 08             	pushl  0x8(%ebp)
80102276:	e8 aa fc ff ff       	call   80101f25 <bmap>
8010227b:	83 c4 10             	add    $0x10,%esp
8010227e:	89 c2                	mov    %eax,%edx
80102280:	8b 45 08             	mov    0x8(%ebp),%eax
80102283:	8b 00                	mov    (%eax),%eax
80102285:	83 ec 08             	sub    $0x8,%esp
80102288:	52                   	push   %edx
80102289:	50                   	push   %eax
8010228a:	e8 27 df ff ff       	call   801001b6 <bread>
8010228f:	83 c4 10             	add    $0x10,%esp
80102292:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102295:	8b 45 10             	mov    0x10(%ebp),%eax
80102298:	25 ff 01 00 00       	and    $0x1ff,%eax
8010229d:	ba 00 02 00 00       	mov    $0x200,%edx
801022a2:	29 c2                	sub    %eax,%edx
801022a4:	8b 45 14             	mov    0x14(%ebp),%eax
801022a7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801022aa:	39 c2                	cmp    %eax,%edx
801022ac:	0f 46 c2             	cmovbe %edx,%eax
801022af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801022b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022b5:	8d 50 18             	lea    0x18(%eax),%edx
801022b8:	8b 45 10             	mov    0x10(%ebp),%eax
801022bb:	25 ff 01 00 00       	and    $0x1ff,%eax
801022c0:	01 d0                	add    %edx,%eax
801022c2:	83 ec 04             	sub    $0x4,%esp
801022c5:	ff 75 ec             	pushl  -0x14(%ebp)
801022c8:	50                   	push   %eax
801022c9:	ff 75 0c             	pushl  0xc(%ebp)
801022cc:	e8 3b 33 00 00       	call   8010560c <memmove>
801022d1:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	ff 75 f0             	pushl  -0x10(%ebp)
801022da:	e8 4f df ff ff       	call   8010022e <brelse>
801022df:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801022e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022e5:	01 45 f4             	add    %eax,-0xc(%ebp)
801022e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022eb:	01 45 10             	add    %eax,0x10(%ebp)
801022ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022f1:	01 45 0c             	add    %eax,0xc(%ebp)
801022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f7:	3b 45 14             	cmp    0x14(%ebp),%eax
801022fa:	0f 82 69 ff ff ff    	jb     80102269 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102300:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102303:	c9                   	leave  
80102304:	c3                   	ret    

80102305 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102305:	55                   	push   %ebp
80102306:	89 e5                	mov    %esp,%ebp
80102308:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010230b:	8b 45 08             	mov    0x8(%ebp),%eax
8010230e:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80102312:	66 83 f8 03          	cmp    $0x3,%ax
80102316:	75 5c                	jne    80102374 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102318:	8b 45 08             	mov    0x8(%ebp),%eax
8010231b:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
8010231f:	66 85 c0             	test   %ax,%ax
80102322:	78 20                	js     80102344 <writei+0x3f>
80102324:	8b 45 08             	mov    0x8(%ebp),%eax
80102327:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
8010232b:	66 83 f8 09          	cmp    $0x9,%ax
8010232f:	7f 13                	jg     80102344 <writei+0x3f>
80102331:	8b 45 08             	mov    0x8(%ebp),%eax
80102334:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80102338:	98                   	cwtl   
80102339:	8b 04 c5 44 23 11 80 	mov    -0x7feedcbc(,%eax,8),%eax
80102340:	85 c0                	test   %eax,%eax
80102342:	75 0a                	jne    8010234e <writei+0x49>
      return -1;
80102344:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102349:	e9 3d 01 00 00       	jmp    8010248b <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010234e:	8b 45 08             	mov    0x8(%ebp),%eax
80102351:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80102355:	98                   	cwtl   
80102356:	8b 04 c5 44 23 11 80 	mov    -0x7feedcbc(,%eax,8),%eax
8010235d:	8b 55 14             	mov    0x14(%ebp),%edx
80102360:	83 ec 04             	sub    $0x4,%esp
80102363:	52                   	push   %edx
80102364:	ff 75 0c             	pushl  0xc(%ebp)
80102367:	ff 75 08             	pushl  0x8(%ebp)
8010236a:	ff d0                	call   *%eax
8010236c:	83 c4 10             	add    $0x10,%esp
8010236f:	e9 17 01 00 00       	jmp    8010248b <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102374:	8b 45 08             	mov    0x8(%ebp),%eax
80102377:	8b 40 20             	mov    0x20(%eax),%eax
8010237a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010237d:	72 0d                	jb     8010238c <writei+0x87>
8010237f:	8b 55 10             	mov    0x10(%ebp),%edx
80102382:	8b 45 14             	mov    0x14(%ebp),%eax
80102385:	01 d0                	add    %edx,%eax
80102387:	3b 45 10             	cmp    0x10(%ebp),%eax
8010238a:	73 0a                	jae    80102396 <writei+0x91>
    return -1;
8010238c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102391:	e9 f5 00 00 00       	jmp    8010248b <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102396:	8b 55 10             	mov    0x10(%ebp),%edx
80102399:	8b 45 14             	mov    0x14(%ebp),%eax
8010239c:	01 d0                	add    %edx,%eax
8010239e:	3d 00 18 01 00       	cmp    $0x11800,%eax
801023a3:	76 0a                	jbe    801023af <writei+0xaa>
    return -1;
801023a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023aa:	e9 dc 00 00 00       	jmp    8010248b <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801023af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801023b6:	e9 99 00 00 00       	jmp    80102454 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801023bb:	8b 45 10             	mov    0x10(%ebp),%eax
801023be:	c1 e8 09             	shr    $0x9,%eax
801023c1:	83 ec 08             	sub    $0x8,%esp
801023c4:	50                   	push   %eax
801023c5:	ff 75 08             	pushl  0x8(%ebp)
801023c8:	e8 58 fb ff ff       	call   80101f25 <bmap>
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	89 c2                	mov    %eax,%edx
801023d2:	8b 45 08             	mov    0x8(%ebp),%eax
801023d5:	8b 00                	mov    (%eax),%eax
801023d7:	83 ec 08             	sub    $0x8,%esp
801023da:	52                   	push   %edx
801023db:	50                   	push   %eax
801023dc:	e8 d5 dd ff ff       	call   801001b6 <bread>
801023e1:	83 c4 10             	add    $0x10,%esp
801023e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801023e7:	8b 45 10             	mov    0x10(%ebp),%eax
801023ea:	25 ff 01 00 00       	and    $0x1ff,%eax
801023ef:	ba 00 02 00 00       	mov    $0x200,%edx
801023f4:	29 c2                	sub    %eax,%edx
801023f6:	8b 45 14             	mov    0x14(%ebp),%eax
801023f9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801023fc:	39 c2                	cmp    %eax,%edx
801023fe:	0f 46 c2             	cmovbe %edx,%eax
80102401:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102404:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102407:	8d 50 18             	lea    0x18(%eax),%edx
8010240a:	8b 45 10             	mov    0x10(%ebp),%eax
8010240d:	25 ff 01 00 00       	and    $0x1ff,%eax
80102412:	01 d0                	add    %edx,%eax
80102414:	83 ec 04             	sub    $0x4,%esp
80102417:	ff 75 ec             	pushl  -0x14(%ebp)
8010241a:	ff 75 0c             	pushl  0xc(%ebp)
8010241d:	50                   	push   %eax
8010241e:	e8 e9 31 00 00       	call   8010560c <memmove>
80102423:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102426:	83 ec 0c             	sub    $0xc,%esp
80102429:	ff 75 f0             	pushl  -0x10(%ebp)
8010242c:	e8 2a 16 00 00       	call   80103a5b <log_write>
80102431:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102434:	83 ec 0c             	sub    $0xc,%esp
80102437:	ff 75 f0             	pushl  -0x10(%ebp)
8010243a:	e8 ef dd ff ff       	call   8010022e <brelse>
8010243f:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102442:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102445:	01 45 f4             	add    %eax,-0xc(%ebp)
80102448:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010244b:	01 45 10             	add    %eax,0x10(%ebp)
8010244e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102451:	01 45 0c             	add    %eax,0xc(%ebp)
80102454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102457:	3b 45 14             	cmp    0x14(%ebp),%eax
8010245a:	0f 82 5b ff ff ff    	jb     801023bb <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102460:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102464:	74 22                	je     80102488 <writei+0x183>
80102466:	8b 45 08             	mov    0x8(%ebp),%eax
80102469:	8b 40 20             	mov    0x20(%eax),%eax
8010246c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010246f:	73 17                	jae    80102488 <writei+0x183>
    ip->size = off;
80102471:	8b 45 08             	mov    0x8(%ebp),%eax
80102474:	8b 55 10             	mov    0x10(%ebp),%edx
80102477:	89 50 20             	mov    %edx,0x20(%eax)
    iupdate(ip);
8010247a:	83 ec 0c             	sub    $0xc,%esp
8010247d:	ff 75 08             	pushl  0x8(%ebp)
80102480:	e8 e1 f5 ff ff       	call   80101a66 <iupdate>
80102485:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102488:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010248b:	c9                   	leave  
8010248c:	c3                   	ret    

8010248d <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010248d:	55                   	push   %ebp
8010248e:	89 e5                	mov    %esp,%ebp
80102490:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102493:	83 ec 04             	sub    $0x4,%esp
80102496:	6a 0e                	push   $0xe
80102498:	ff 75 0c             	pushl  0xc(%ebp)
8010249b:	ff 75 08             	pushl  0x8(%ebp)
8010249e:	e8 ff 31 00 00       	call   801056a2 <strncmp>
801024a3:	83 c4 10             	add    $0x10,%esp
}
801024a6:	c9                   	leave  
801024a7:	c3                   	ret    

801024a8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801024a8:	55                   	push   %ebp
801024a9:	89 e5                	mov    %esp,%ebp
801024ab:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801024ae:	8b 45 08             	mov    0x8(%ebp),%eax
801024b1:	0f b7 40 18          	movzwl 0x18(%eax),%eax
801024b5:	66 83 f8 01          	cmp    $0x1,%ax
801024b9:	74 0d                	je     801024c8 <dirlookup+0x20>
    panic("dirlookup not DIR");
801024bb:	83 ec 0c             	sub    $0xc,%esp
801024be:	68 13 8f 10 80       	push   $0x80108f13
801024c3:	e8 9e e0 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801024c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801024cf:	eb 7b                	jmp    8010254c <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024d1:	6a 10                	push   $0x10
801024d3:	ff 75 f4             	pushl  -0xc(%ebp)
801024d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024d9:	50                   	push   %eax
801024da:	ff 75 08             	pushl  0x8(%ebp)
801024dd:	e8 cc fc ff ff       	call   801021ae <readi>
801024e2:	83 c4 10             	add    $0x10,%esp
801024e5:	83 f8 10             	cmp    $0x10,%eax
801024e8:	74 0d                	je     801024f7 <dirlookup+0x4f>
      panic("dirlink read");
801024ea:	83 ec 0c             	sub    $0xc,%esp
801024ed:	68 25 8f 10 80       	push   $0x80108f25
801024f2:	e8 6f e0 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801024f7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801024fb:	66 85 c0             	test   %ax,%ax
801024fe:	74 47                	je     80102547 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102500:	83 ec 08             	sub    $0x8,%esp
80102503:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102506:	83 c0 02             	add    $0x2,%eax
80102509:	50                   	push   %eax
8010250a:	ff 75 0c             	pushl  0xc(%ebp)
8010250d:	e8 7b ff ff ff       	call   8010248d <namecmp>
80102512:	83 c4 10             	add    $0x10,%esp
80102515:	85 c0                	test   %eax,%eax
80102517:	75 2f                	jne    80102548 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102519:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010251d:	74 08                	je     80102527 <dirlookup+0x7f>
        *poff = off;
8010251f:	8b 45 10             	mov    0x10(%ebp),%eax
80102522:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102525:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102527:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010252b:	0f b7 c0             	movzwl %ax,%eax
8010252e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102531:	8b 45 08             	mov    0x8(%ebp),%eax
80102534:	8b 00                	mov    (%eax),%eax
80102536:	83 ec 08             	sub    $0x8,%esp
80102539:	ff 75 f0             	pushl  -0x10(%ebp)
8010253c:	50                   	push   %eax
8010253d:	e8 e5 f5 ff ff       	call   80101b27 <iget>
80102542:	83 c4 10             	add    $0x10,%esp
80102545:	eb 19                	jmp    80102560 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102547:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102548:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010254c:	8b 45 08             	mov    0x8(%ebp),%eax
8010254f:	8b 40 20             	mov    0x20(%eax),%eax
80102552:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102555:	0f 87 76 ff ff ff    	ja     801024d1 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010255b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102560:	c9                   	leave  
80102561:	c3                   	ret    

80102562 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102562:	55                   	push   %ebp
80102563:	89 e5                	mov    %esp,%ebp
80102565:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102568:	83 ec 04             	sub    $0x4,%esp
8010256b:	6a 00                	push   $0x0
8010256d:	ff 75 0c             	pushl  0xc(%ebp)
80102570:	ff 75 08             	pushl  0x8(%ebp)
80102573:	e8 30 ff ff ff       	call   801024a8 <dirlookup>
80102578:	83 c4 10             	add    $0x10,%esp
8010257b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010257e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102582:	74 18                	je     8010259c <dirlink+0x3a>
    iput(ip);
80102584:	83 ec 0c             	sub    $0xc,%esp
80102587:	ff 75 f0             	pushl  -0x10(%ebp)
8010258a:	e8 81 f8 ff ff       	call   80101e10 <iput>
8010258f:	83 c4 10             	add    $0x10,%esp
    return -1;
80102592:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102597:	e9 9c 00 00 00       	jmp    80102638 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010259c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025a3:	eb 39                	jmp    801025de <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025a8:	6a 10                	push   $0x10
801025aa:	50                   	push   %eax
801025ab:	8d 45 e0             	lea    -0x20(%ebp),%eax
801025ae:	50                   	push   %eax
801025af:	ff 75 08             	pushl  0x8(%ebp)
801025b2:	e8 f7 fb ff ff       	call   801021ae <readi>
801025b7:	83 c4 10             	add    $0x10,%esp
801025ba:	83 f8 10             	cmp    $0x10,%eax
801025bd:	74 0d                	je     801025cc <dirlink+0x6a>
      panic("dirlink read");
801025bf:	83 ec 0c             	sub    $0xc,%esp
801025c2:	68 25 8f 10 80       	push   $0x80108f25
801025c7:	e8 9a df ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801025cc:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801025d0:	66 85 c0             	test   %ax,%ax
801025d3:	74 18                	je     801025ed <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025d8:	83 c0 10             	add    $0x10,%eax
801025db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801025de:	8b 45 08             	mov    0x8(%ebp),%eax
801025e1:	8b 50 20             	mov    0x20(%eax),%edx
801025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025e7:	39 c2                	cmp    %eax,%edx
801025e9:	77 ba                	ja     801025a5 <dirlink+0x43>
801025eb:	eb 01                	jmp    801025ee <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801025ed:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801025ee:	83 ec 04             	sub    $0x4,%esp
801025f1:	6a 0e                	push   $0xe
801025f3:	ff 75 0c             	pushl  0xc(%ebp)
801025f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801025f9:	83 c0 02             	add    $0x2,%eax
801025fc:	50                   	push   %eax
801025fd:	e8 f6 30 00 00       	call   801056f8 <strncpy>
80102602:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102605:	8b 45 10             	mov    0x10(%ebp),%eax
80102608:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010260f:	6a 10                	push   $0x10
80102611:	50                   	push   %eax
80102612:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102615:	50                   	push   %eax
80102616:	ff 75 08             	pushl  0x8(%ebp)
80102619:	e8 e7 fc ff ff       	call   80102305 <writei>
8010261e:	83 c4 10             	add    $0x10,%esp
80102621:	83 f8 10             	cmp    $0x10,%eax
80102624:	74 0d                	je     80102633 <dirlink+0xd1>
    panic("dirlink");
80102626:	83 ec 0c             	sub    $0xc,%esp
80102629:	68 32 8f 10 80       	push   $0x80108f32
8010262e:	e8 33 df ff ff       	call   80100566 <panic>
  
  return 0;
80102633:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102638:	c9                   	leave  
80102639:	c3                   	ret    

8010263a <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010263a:	55                   	push   %ebp
8010263b:	89 e5                	mov    %esp,%ebp
8010263d:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102640:	eb 04                	jmp    80102646 <skipelem+0xc>
    path++;
80102642:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102646:	8b 45 08             	mov    0x8(%ebp),%eax
80102649:	0f b6 00             	movzbl (%eax),%eax
8010264c:	3c 2f                	cmp    $0x2f,%al
8010264e:	74 f2                	je     80102642 <skipelem+0x8>
    path++;
  if(*path == 0)
80102650:	8b 45 08             	mov    0x8(%ebp),%eax
80102653:	0f b6 00             	movzbl (%eax),%eax
80102656:	84 c0                	test   %al,%al
80102658:	75 07                	jne    80102661 <skipelem+0x27>
    return 0;
8010265a:	b8 00 00 00 00       	mov    $0x0,%eax
8010265f:	eb 7b                	jmp    801026dc <skipelem+0xa2>
  s = path;
80102661:	8b 45 08             	mov    0x8(%ebp),%eax
80102664:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102667:	eb 04                	jmp    8010266d <skipelem+0x33>
    path++;
80102669:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010266d:	8b 45 08             	mov    0x8(%ebp),%eax
80102670:	0f b6 00             	movzbl (%eax),%eax
80102673:	3c 2f                	cmp    $0x2f,%al
80102675:	74 0a                	je     80102681 <skipelem+0x47>
80102677:	8b 45 08             	mov    0x8(%ebp),%eax
8010267a:	0f b6 00             	movzbl (%eax),%eax
8010267d:	84 c0                	test   %al,%al
8010267f:	75 e8                	jne    80102669 <skipelem+0x2f>
    path++;
  len = path - s;
80102681:	8b 55 08             	mov    0x8(%ebp),%edx
80102684:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102687:	29 c2                	sub    %eax,%edx
80102689:	89 d0                	mov    %edx,%eax
8010268b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010268e:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102692:	7e 15                	jle    801026a9 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102694:	83 ec 04             	sub    $0x4,%esp
80102697:	6a 0e                	push   $0xe
80102699:	ff 75 f4             	pushl  -0xc(%ebp)
8010269c:	ff 75 0c             	pushl  0xc(%ebp)
8010269f:	e8 68 2f 00 00       	call   8010560c <memmove>
801026a4:	83 c4 10             	add    $0x10,%esp
801026a7:	eb 26                	jmp    801026cf <skipelem+0x95>
  else {
    memmove(name, s, len);
801026a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026ac:	83 ec 04             	sub    $0x4,%esp
801026af:	50                   	push   %eax
801026b0:	ff 75 f4             	pushl  -0xc(%ebp)
801026b3:	ff 75 0c             	pushl  0xc(%ebp)
801026b6:	e8 51 2f 00 00       	call   8010560c <memmove>
801026bb:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801026be:	8b 55 f0             	mov    -0x10(%ebp),%edx
801026c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801026c4:	01 d0                	add    %edx,%eax
801026c6:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801026c9:	eb 04                	jmp    801026cf <skipelem+0x95>
    path++;
801026cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801026cf:	8b 45 08             	mov    0x8(%ebp),%eax
801026d2:	0f b6 00             	movzbl (%eax),%eax
801026d5:	3c 2f                	cmp    $0x2f,%al
801026d7:	74 f2                	je     801026cb <skipelem+0x91>
    path++;
  return path;
801026d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801026dc:	c9                   	leave  
801026dd:	c3                   	ret    

801026de <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801026de:	55                   	push   %ebp
801026df:	89 e5                	mov    %esp,%ebp
801026e1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801026e4:	8b 45 08             	mov    0x8(%ebp),%eax
801026e7:	0f b6 00             	movzbl (%eax),%eax
801026ea:	3c 2f                	cmp    $0x2f,%al
801026ec:	75 17                	jne    80102705 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801026ee:	83 ec 08             	sub    $0x8,%esp
801026f1:	6a 01                	push   $0x1
801026f3:	6a 01                	push   $0x1
801026f5:	e8 2d f4 ff ff       	call   80101b27 <iget>
801026fa:	83 c4 10             	add    $0x10,%esp
801026fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102700:	e9 bb 00 00 00       	jmp    801027c0 <namex+0xe2>
  else
    ip = idup(proc->cwd);
80102705:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010270b:	8b 40 68             	mov    0x68(%eax),%eax
8010270e:	83 ec 0c             	sub    $0xc,%esp
80102711:	50                   	push   %eax
80102712:	e8 ef f4 ff ff       	call   80101c06 <idup>
80102717:	83 c4 10             	add    $0x10,%esp
8010271a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010271d:	e9 9e 00 00 00       	jmp    801027c0 <namex+0xe2>
    ilock(ip);
80102722:	83 ec 0c             	sub    $0xc,%esp
80102725:	ff 75 f4             	pushl  -0xc(%ebp)
80102728:	e8 13 f5 ff ff       	call   80101c40 <ilock>
8010272d:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102733:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80102737:	66 83 f8 01          	cmp    $0x1,%ax
8010273b:	74 18                	je     80102755 <namex+0x77>
      iunlockput(ip);
8010273d:	83 ec 0c             	sub    $0xc,%esp
80102740:	ff 75 f4             	pushl  -0xc(%ebp)
80102743:	e8 b8 f7 ff ff       	call   80101f00 <iunlockput>
80102748:	83 c4 10             	add    $0x10,%esp
      return 0;
8010274b:	b8 00 00 00 00       	mov    $0x0,%eax
80102750:	e9 a7 00 00 00       	jmp    801027fc <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102755:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102759:	74 20                	je     8010277b <namex+0x9d>
8010275b:	8b 45 08             	mov    0x8(%ebp),%eax
8010275e:	0f b6 00             	movzbl (%eax),%eax
80102761:	84 c0                	test   %al,%al
80102763:	75 16                	jne    8010277b <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102765:	83 ec 0c             	sub    $0xc,%esp
80102768:	ff 75 f4             	pushl  -0xc(%ebp)
8010276b:	e8 2e f6 ff ff       	call   80101d9e <iunlock>
80102770:	83 c4 10             	add    $0x10,%esp
      return ip;
80102773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102776:	e9 81 00 00 00       	jmp    801027fc <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010277b:	83 ec 04             	sub    $0x4,%esp
8010277e:	6a 00                	push   $0x0
80102780:	ff 75 10             	pushl  0x10(%ebp)
80102783:	ff 75 f4             	pushl  -0xc(%ebp)
80102786:	e8 1d fd ff ff       	call   801024a8 <dirlookup>
8010278b:	83 c4 10             	add    $0x10,%esp
8010278e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102791:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102795:	75 15                	jne    801027ac <namex+0xce>
      iunlockput(ip);
80102797:	83 ec 0c             	sub    $0xc,%esp
8010279a:	ff 75 f4             	pushl  -0xc(%ebp)
8010279d:	e8 5e f7 ff ff       	call   80101f00 <iunlockput>
801027a2:	83 c4 10             	add    $0x10,%esp
      return 0;
801027a5:	b8 00 00 00 00       	mov    $0x0,%eax
801027aa:	eb 50                	jmp    801027fc <namex+0x11e>
    }
    iunlockput(ip);
801027ac:	83 ec 0c             	sub    $0xc,%esp
801027af:	ff 75 f4             	pushl  -0xc(%ebp)
801027b2:	e8 49 f7 ff ff       	call   80101f00 <iunlockput>
801027b7:	83 c4 10             	add    $0x10,%esp
    ip = next;
801027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801027c0:	83 ec 08             	sub    $0x8,%esp
801027c3:	ff 75 10             	pushl  0x10(%ebp)
801027c6:	ff 75 08             	pushl  0x8(%ebp)
801027c9:	e8 6c fe ff ff       	call   8010263a <skipelem>
801027ce:	83 c4 10             	add    $0x10,%esp
801027d1:	89 45 08             	mov    %eax,0x8(%ebp)
801027d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801027d8:	0f 85 44 ff ff ff    	jne    80102722 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801027de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801027e2:	74 15                	je     801027f9 <namex+0x11b>
    iput(ip);
801027e4:	83 ec 0c             	sub    $0xc,%esp
801027e7:	ff 75 f4             	pushl  -0xc(%ebp)
801027ea:	e8 21 f6 ff ff       	call   80101e10 <iput>
801027ef:	83 c4 10             	add    $0x10,%esp
    return 0;
801027f2:	b8 00 00 00 00       	mov    $0x0,%eax
801027f7:	eb 03                	jmp    801027fc <namex+0x11e>
  }
  return ip;
801027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801027fc:	c9                   	leave  
801027fd:	c3                   	ret    

801027fe <namei>:

struct inode*
namei(char *path)
{
801027fe:	55                   	push   %ebp
801027ff:	89 e5                	mov    %esp,%ebp
80102801:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102804:	83 ec 04             	sub    $0x4,%esp
80102807:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010280a:	50                   	push   %eax
8010280b:	6a 00                	push   $0x0
8010280d:	ff 75 08             	pushl  0x8(%ebp)
80102810:	e8 c9 fe ff ff       	call   801026de <namex>
80102815:	83 c4 10             	add    $0x10,%esp
}
80102818:	c9                   	leave  
80102819:	c3                   	ret    

8010281a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010281a:	55                   	push   %ebp
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102820:	83 ec 04             	sub    $0x4,%esp
80102823:	ff 75 0c             	pushl  0xc(%ebp)
80102826:	6a 01                	push   $0x1
80102828:	ff 75 08             	pushl  0x8(%ebp)
8010282b:	e8 ae fe ff ff       	call   801026de <namex>
80102830:	83 c4 10             	add    $0x10,%esp
}
80102833:	c9                   	leave  
80102834:	c3                   	ret    

80102835 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102835:	55                   	push   %ebp
80102836:	89 e5                	mov    %esp,%ebp
80102838:	83 ec 14             	sub    $0x14,%esp
8010283b:	8b 45 08             	mov    0x8(%ebp),%eax
8010283e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102842:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102846:	89 c2                	mov    %eax,%edx
80102848:	ec                   	in     (%dx),%al
80102849:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010284c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102850:	c9                   	leave  
80102851:	c3                   	ret    

80102852 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102852:	55                   	push   %ebp
80102853:	89 e5                	mov    %esp,%ebp
80102855:	57                   	push   %edi
80102856:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102857:	8b 55 08             	mov    0x8(%ebp),%edx
8010285a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010285d:	8b 45 10             	mov    0x10(%ebp),%eax
80102860:	89 cb                	mov    %ecx,%ebx
80102862:	89 df                	mov    %ebx,%edi
80102864:	89 c1                	mov    %eax,%ecx
80102866:	fc                   	cld    
80102867:	f3 6d                	rep insl (%dx),%es:(%edi)
80102869:	89 c8                	mov    %ecx,%eax
8010286b:	89 fb                	mov    %edi,%ebx
8010286d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102870:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102873:	90                   	nop
80102874:	5b                   	pop    %ebx
80102875:	5f                   	pop    %edi
80102876:	5d                   	pop    %ebp
80102877:	c3                   	ret    

80102878 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102878:	55                   	push   %ebp
80102879:	89 e5                	mov    %esp,%ebp
8010287b:	83 ec 08             	sub    $0x8,%esp
8010287e:	8b 55 08             	mov    0x8(%ebp),%edx
80102881:	8b 45 0c             	mov    0xc(%ebp),%eax
80102884:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102888:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010288f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102893:	ee                   	out    %al,(%dx)
}
80102894:	90                   	nop
80102895:	c9                   	leave  
80102896:	c3                   	ret    

80102897 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102897:	55                   	push   %ebp
80102898:	89 e5                	mov    %esp,%ebp
8010289a:	56                   	push   %esi
8010289b:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010289c:	8b 55 08             	mov    0x8(%ebp),%edx
8010289f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028a2:	8b 45 10             	mov    0x10(%ebp),%eax
801028a5:	89 cb                	mov    %ecx,%ebx
801028a7:	89 de                	mov    %ebx,%esi
801028a9:	89 c1                	mov    %eax,%ecx
801028ab:	fc                   	cld    
801028ac:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801028ae:	89 c8                	mov    %ecx,%eax
801028b0:	89 f3                	mov    %esi,%ebx
801028b2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801028b5:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801028b8:	90                   	nop
801028b9:	5b                   	pop    %ebx
801028ba:	5e                   	pop    %esi
801028bb:	5d                   	pop    %ebp
801028bc:	c3                   	ret    

801028bd <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801028bd:	55                   	push   %ebp
801028be:	89 e5                	mov    %esp,%ebp
801028c0:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801028c3:	90                   	nop
801028c4:	68 f7 01 00 00       	push   $0x1f7
801028c9:	e8 67 ff ff ff       	call   80102835 <inb>
801028ce:	83 c4 04             	add    $0x4,%esp
801028d1:	0f b6 c0             	movzbl %al,%eax
801028d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
801028d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028da:	25 c0 00 00 00       	and    $0xc0,%eax
801028df:	83 f8 40             	cmp    $0x40,%eax
801028e2:	75 e0                	jne    801028c4 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801028e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801028e8:	74 11                	je     801028fb <idewait+0x3e>
801028ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028ed:	83 e0 21             	and    $0x21,%eax
801028f0:	85 c0                	test   %eax,%eax
801028f2:	74 07                	je     801028fb <idewait+0x3e>
    return -1;
801028f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801028f9:	eb 05                	jmp    80102900 <idewait+0x43>
  return 0;
801028fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102900:	c9                   	leave  
80102901:	c3                   	ret    

80102902 <ideinit>:

void
ideinit(void)
{
80102902:	55                   	push   %ebp
80102903:	89 e5                	mov    %esp,%ebp
80102905:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102908:	83 ec 08             	sub    $0x8,%esp
8010290b:	68 3a 8f 10 80       	push   $0x80108f3a
80102910:	68 40 c6 10 80       	push   $0x8010c640
80102915:	e8 ae 29 00 00       	call   801052c8 <initlock>
8010291a:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
8010291d:	83 ec 0c             	sub    $0xc,%esp
80102920:	6a 0e                	push   $0xe
80102922:	e8 da 18 00 00       	call   80104201 <picenable>
80102927:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010292a:	a1 60 3c 11 80       	mov    0x80113c60,%eax
8010292f:	83 e8 01             	sub    $0x1,%eax
80102932:	83 ec 08             	sub    $0x8,%esp
80102935:	50                   	push   %eax
80102936:	6a 0e                	push   $0xe
80102938:	e8 73 04 00 00       	call   80102db0 <ioapicenable>
8010293d:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102940:	83 ec 0c             	sub    $0xc,%esp
80102943:	6a 00                	push   $0x0
80102945:	e8 73 ff ff ff       	call   801028bd <idewait>
8010294a:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010294d:	83 ec 08             	sub    $0x8,%esp
80102950:	68 f0 00 00 00       	push   $0xf0
80102955:	68 f6 01 00 00       	push   $0x1f6
8010295a:	e8 19 ff ff ff       	call   80102878 <outb>
8010295f:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102969:	eb 24                	jmp    8010298f <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010296b:	83 ec 0c             	sub    $0xc,%esp
8010296e:	68 f7 01 00 00       	push   $0x1f7
80102973:	e8 bd fe ff ff       	call   80102835 <inb>
80102978:	83 c4 10             	add    $0x10,%esp
8010297b:	84 c0                	test   %al,%al
8010297d:	74 0c                	je     8010298b <ideinit+0x89>
      havedisk1 = 1;
8010297f:	c7 05 78 c6 10 80 01 	movl   $0x1,0x8010c678
80102986:	00 00 00 
      break;
80102989:	eb 0d                	jmp    80102998 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010298b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010298f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102996:	7e d3                	jle    8010296b <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102998:	83 ec 08             	sub    $0x8,%esp
8010299b:	68 e0 00 00 00       	push   $0xe0
801029a0:	68 f6 01 00 00       	push   $0x1f6
801029a5:	e8 ce fe ff ff       	call   80102878 <outb>
801029aa:	83 c4 10             	add    $0x10,%esp
}
801029ad:	90                   	nop
801029ae:	c9                   	leave  
801029af:	c3                   	ret    

801029b0 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801029b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801029ba:	75 0d                	jne    801029c9 <idestart+0x19>
    panic("idestart");
801029bc:	83 ec 0c             	sub    $0xc,%esp
801029bf:	68 3e 8f 10 80       	push   $0x80108f3e
801029c4:	e8 9d db ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801029c9:	8b 45 08             	mov    0x8(%ebp),%eax
801029cc:	8b 40 08             	mov    0x8(%eax),%eax
801029cf:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801029d4:	76 0d                	jbe    801029e3 <idestart+0x33>
    panic("incorrect blockno");
801029d6:	83 ec 0c             	sub    $0xc,%esp
801029d9:	68 47 8f 10 80       	push   $0x80108f47
801029de:	e8 83 db ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801029e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801029ea:	8b 45 08             	mov    0x8(%ebp),%eax
801029ed:	8b 50 08             	mov    0x8(%eax),%edx
801029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f3:	0f af c2             	imul   %edx,%eax
801029f6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801029f9:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801029fd:	7e 0d                	jle    80102a0c <idestart+0x5c>
801029ff:	83 ec 0c             	sub    $0xc,%esp
80102a02:	68 3e 8f 10 80       	push   $0x80108f3e
80102a07:	e8 5a db ff ff       	call   80100566 <panic>
  
  idewait(0);
80102a0c:	83 ec 0c             	sub    $0xc,%esp
80102a0f:	6a 00                	push   $0x0
80102a11:	e8 a7 fe ff ff       	call   801028bd <idewait>
80102a16:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102a19:	83 ec 08             	sub    $0x8,%esp
80102a1c:	6a 00                	push   $0x0
80102a1e:	68 f6 03 00 00       	push   $0x3f6
80102a23:	e8 50 fe ff ff       	call   80102878 <outb>
80102a28:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2e:	0f b6 c0             	movzbl %al,%eax
80102a31:	83 ec 08             	sub    $0x8,%esp
80102a34:	50                   	push   %eax
80102a35:	68 f2 01 00 00       	push   $0x1f2
80102a3a:	e8 39 fe ff ff       	call   80102878 <outb>
80102a3f:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a45:	0f b6 c0             	movzbl %al,%eax
80102a48:	83 ec 08             	sub    $0x8,%esp
80102a4b:	50                   	push   %eax
80102a4c:	68 f3 01 00 00       	push   $0x1f3
80102a51:	e8 22 fe ff ff       	call   80102878 <outb>
80102a56:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a5c:	c1 f8 08             	sar    $0x8,%eax
80102a5f:	0f b6 c0             	movzbl %al,%eax
80102a62:	83 ec 08             	sub    $0x8,%esp
80102a65:	50                   	push   %eax
80102a66:	68 f4 01 00 00       	push   $0x1f4
80102a6b:	e8 08 fe ff ff       	call   80102878 <outb>
80102a70:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a76:	c1 f8 10             	sar    $0x10,%eax
80102a79:	0f b6 c0             	movzbl %al,%eax
80102a7c:	83 ec 08             	sub    $0x8,%esp
80102a7f:	50                   	push   %eax
80102a80:	68 f5 01 00 00       	push   $0x1f5
80102a85:	e8 ee fd ff ff       	call   80102878 <outb>
80102a8a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a90:	8b 40 04             	mov    0x4(%eax),%eax
80102a93:	83 e0 01             	and    $0x1,%eax
80102a96:	c1 e0 04             	shl    $0x4,%eax
80102a99:	89 c2                	mov    %eax,%edx
80102a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a9e:	c1 f8 18             	sar    $0x18,%eax
80102aa1:	83 e0 0f             	and    $0xf,%eax
80102aa4:	09 d0                	or     %edx,%eax
80102aa6:	83 c8 e0             	or     $0xffffffe0,%eax
80102aa9:	0f b6 c0             	movzbl %al,%eax
80102aac:	83 ec 08             	sub    $0x8,%esp
80102aaf:	50                   	push   %eax
80102ab0:	68 f6 01 00 00       	push   $0x1f6
80102ab5:	e8 be fd ff ff       	call   80102878 <outb>
80102aba:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102abd:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac0:	8b 00                	mov    (%eax),%eax
80102ac2:	83 e0 04             	and    $0x4,%eax
80102ac5:	85 c0                	test   %eax,%eax
80102ac7:	74 30                	je     80102af9 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102ac9:	83 ec 08             	sub    $0x8,%esp
80102acc:	6a 30                	push   $0x30
80102ace:	68 f7 01 00 00       	push   $0x1f7
80102ad3:	e8 a0 fd ff ff       	call   80102878 <outb>
80102ad8:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102adb:	8b 45 08             	mov    0x8(%ebp),%eax
80102ade:	83 c0 18             	add    $0x18,%eax
80102ae1:	83 ec 04             	sub    $0x4,%esp
80102ae4:	68 80 00 00 00       	push   $0x80
80102ae9:	50                   	push   %eax
80102aea:	68 f0 01 00 00       	push   $0x1f0
80102aef:	e8 a3 fd ff ff       	call   80102897 <outsl>
80102af4:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102af7:	eb 12                	jmp    80102b0b <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102af9:	83 ec 08             	sub    $0x8,%esp
80102afc:	6a 20                	push   $0x20
80102afe:	68 f7 01 00 00       	push   $0x1f7
80102b03:	e8 70 fd ff ff       	call   80102878 <outb>
80102b08:	83 c4 10             	add    $0x10,%esp
  }
}
80102b0b:	90                   	nop
80102b0c:	c9                   	leave  
80102b0d:	c3                   	ret    

80102b0e <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102b0e:	55                   	push   %ebp
80102b0f:	89 e5                	mov    %esp,%ebp
80102b11:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102b14:	83 ec 0c             	sub    $0xc,%esp
80102b17:	68 40 c6 10 80       	push   $0x8010c640
80102b1c:	e8 c9 27 00 00       	call   801052ea <acquire>
80102b21:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102b24:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b30:	75 15                	jne    80102b47 <ideintr+0x39>
    release(&idelock);
80102b32:	83 ec 0c             	sub    $0xc,%esp
80102b35:	68 40 c6 10 80       	push   $0x8010c640
80102b3a:	e8 12 28 00 00       	call   80105351 <release>
80102b3f:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102b42:	e9 9a 00 00 00       	jmp    80102be1 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b4a:	8b 40 14             	mov    0x14(%eax),%eax
80102b4d:	a3 74 c6 10 80       	mov    %eax,0x8010c674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b55:	8b 00                	mov    (%eax),%eax
80102b57:	83 e0 04             	and    $0x4,%eax
80102b5a:	85 c0                	test   %eax,%eax
80102b5c:	75 2d                	jne    80102b8b <ideintr+0x7d>
80102b5e:	83 ec 0c             	sub    $0xc,%esp
80102b61:	6a 01                	push   $0x1
80102b63:	e8 55 fd ff ff       	call   801028bd <idewait>
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 c0                	test   %eax,%eax
80102b6d:	78 1c                	js     80102b8b <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b72:	83 c0 18             	add    $0x18,%eax
80102b75:	83 ec 04             	sub    $0x4,%esp
80102b78:	68 80 00 00 00       	push   $0x80
80102b7d:	50                   	push   %eax
80102b7e:	68 f0 01 00 00       	push   $0x1f0
80102b83:	e8 ca fc ff ff       	call   80102852 <insl>
80102b88:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b8e:	8b 00                	mov    (%eax),%eax
80102b90:	83 c8 02             	or     $0x2,%eax
80102b93:	89 c2                	mov    %eax,%edx
80102b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b98:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9d:	8b 00                	mov    (%eax),%eax
80102b9f:	83 e0 fb             	and    $0xfffffffb,%eax
80102ba2:	89 c2                	mov    %eax,%edx
80102ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba7:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102ba9:	83 ec 0c             	sub    $0xc,%esp
80102bac:	ff 75 f4             	pushl  -0xc(%ebp)
80102baf:	e8 22 25 00 00       	call   801050d6 <wakeup>
80102bb4:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102bb7:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102bbc:	85 c0                	test   %eax,%eax
80102bbe:	74 11                	je     80102bd1 <ideintr+0xc3>
    idestart(idequeue);
80102bc0:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102bc5:	83 ec 0c             	sub    $0xc,%esp
80102bc8:	50                   	push   %eax
80102bc9:	e8 e2 fd ff ff       	call   801029b0 <idestart>
80102bce:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102bd1:	83 ec 0c             	sub    $0xc,%esp
80102bd4:	68 40 c6 10 80       	push   $0x8010c640
80102bd9:	e8 73 27 00 00       	call   80105351 <release>
80102bde:	83 c4 10             	add    $0x10,%esp
}
80102be1:	c9                   	leave  
80102be2:	c3                   	ret    

80102be3 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102be3:	55                   	push   %ebp
80102be4:	89 e5                	mov    %esp,%ebp
80102be6:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102be9:	8b 45 08             	mov    0x8(%ebp),%eax
80102bec:	8b 00                	mov    (%eax),%eax
80102bee:	83 e0 01             	and    $0x1,%eax
80102bf1:	85 c0                	test   %eax,%eax
80102bf3:	75 0d                	jne    80102c02 <iderw+0x1f>
    panic("iderw: buf not busy");
80102bf5:	83 ec 0c             	sub    $0xc,%esp
80102bf8:	68 59 8f 10 80       	push   $0x80108f59
80102bfd:	e8 64 d9 ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102c02:	8b 45 08             	mov    0x8(%ebp),%eax
80102c05:	8b 00                	mov    (%eax),%eax
80102c07:	83 e0 06             	and    $0x6,%eax
80102c0a:	83 f8 02             	cmp    $0x2,%eax
80102c0d:	75 0d                	jne    80102c1c <iderw+0x39>
    panic("iderw: nothing to do");
80102c0f:	83 ec 0c             	sub    $0xc,%esp
80102c12:	68 6d 8f 10 80       	push   $0x80108f6d
80102c17:	e8 4a d9 ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80102c1f:	8b 40 04             	mov    0x4(%eax),%eax
80102c22:	85 c0                	test   %eax,%eax
80102c24:	74 16                	je     80102c3c <iderw+0x59>
80102c26:	a1 78 c6 10 80       	mov    0x8010c678,%eax
80102c2b:	85 c0                	test   %eax,%eax
80102c2d:	75 0d                	jne    80102c3c <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102c2f:	83 ec 0c             	sub    $0xc,%esp
80102c32:	68 82 8f 10 80       	push   $0x80108f82
80102c37:	e8 2a d9 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102c3c:	83 ec 0c             	sub    $0xc,%esp
80102c3f:	68 40 c6 10 80       	push   $0x8010c640
80102c44:	e8 a1 26 00 00       	call   801052ea <acquire>
80102c49:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80102c4f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c56:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
80102c5d:	eb 0b                	jmp    80102c6a <iderw+0x87>
80102c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c62:	8b 00                	mov    (%eax),%eax
80102c64:	83 c0 14             	add    $0x14,%eax
80102c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6d:	8b 00                	mov    (%eax),%eax
80102c6f:	85 c0                	test   %eax,%eax
80102c71:	75 ec                	jne    80102c5f <iderw+0x7c>
    ;
  *pp = b;
80102c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c76:	8b 55 08             	mov    0x8(%ebp),%edx
80102c79:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102c7b:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102c80:	3b 45 08             	cmp    0x8(%ebp),%eax
80102c83:	75 23                	jne    80102ca8 <iderw+0xc5>
    idestart(b);
80102c85:	83 ec 0c             	sub    $0xc,%esp
80102c88:	ff 75 08             	pushl  0x8(%ebp)
80102c8b:	e8 20 fd ff ff       	call   801029b0 <idestart>
80102c90:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c93:	eb 13                	jmp    80102ca8 <iderw+0xc5>
    sleep(b, &idelock);
80102c95:	83 ec 08             	sub    $0x8,%esp
80102c98:	68 40 c6 10 80       	push   $0x8010c640
80102c9d:	ff 75 08             	pushl  0x8(%ebp)
80102ca0:	e8 43 23 00 00       	call   80104fe8 <sleep>
80102ca5:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80102cab:	8b 00                	mov    (%eax),%eax
80102cad:	83 e0 06             	and    $0x6,%eax
80102cb0:	83 f8 02             	cmp    $0x2,%eax
80102cb3:	75 e0                	jne    80102c95 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102cb5:	83 ec 0c             	sub    $0xc,%esp
80102cb8:	68 40 c6 10 80       	push   $0x8010c640
80102cbd:	e8 8f 26 00 00       	call   80105351 <release>
80102cc2:	83 c4 10             	add    $0x10,%esp
}
80102cc5:	90                   	nop
80102cc6:	c9                   	leave  
80102cc7:	c3                   	ret    

80102cc8 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102cc8:	55                   	push   %ebp
80102cc9:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ccb:	a1 24 35 11 80       	mov    0x80113524,%eax
80102cd0:	8b 55 08             	mov    0x8(%ebp),%edx
80102cd3:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102cd5:	a1 24 35 11 80       	mov    0x80113524,%eax
80102cda:	8b 40 10             	mov    0x10(%eax),%eax
}
80102cdd:	5d                   	pop    %ebp
80102cde:	c3                   	ret    

80102cdf <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102cdf:	55                   	push   %ebp
80102ce0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ce2:	a1 24 35 11 80       	mov    0x80113524,%eax
80102ce7:	8b 55 08             	mov    0x8(%ebp),%edx
80102cea:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102cec:	a1 24 35 11 80       	mov    0x80113524,%eax
80102cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
80102cf4:	89 50 10             	mov    %edx,0x10(%eax)
}
80102cf7:	90                   	nop
80102cf8:	5d                   	pop    %ebp
80102cf9:	c3                   	ret    

80102cfa <ioapicinit>:

void
ioapicinit(void)
{
80102cfa:	55                   	push   %ebp
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102d00:	a1 64 36 11 80       	mov    0x80113664,%eax
80102d05:	85 c0                	test   %eax,%eax
80102d07:	0f 84 a0 00 00 00    	je     80102dad <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102d0d:	c7 05 24 35 11 80 00 	movl   $0xfec00000,0x80113524
80102d14:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102d17:	6a 01                	push   $0x1
80102d19:	e8 aa ff ff ff       	call   80102cc8 <ioapicread>
80102d1e:	83 c4 04             	add    $0x4,%esp
80102d21:	c1 e8 10             	shr    $0x10,%eax
80102d24:	25 ff 00 00 00       	and    $0xff,%eax
80102d29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102d2c:	6a 00                	push   $0x0
80102d2e:	e8 95 ff ff ff       	call   80102cc8 <ioapicread>
80102d33:	83 c4 04             	add    $0x4,%esp
80102d36:	c1 e8 18             	shr    $0x18,%eax
80102d39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102d3c:	0f b6 05 60 36 11 80 	movzbl 0x80113660,%eax
80102d43:	0f b6 c0             	movzbl %al,%eax
80102d46:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102d49:	74 10                	je     80102d5b <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102d4b:	83 ec 0c             	sub    $0xc,%esp
80102d4e:	68 a0 8f 10 80       	push   $0x80108fa0
80102d53:	e8 6e d6 ff ff       	call   801003c6 <cprintf>
80102d58:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102d5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102d62:	eb 3f                	jmp    80102da3 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d67:	83 c0 20             	add    $0x20,%eax
80102d6a:	0d 00 00 01 00       	or     $0x10000,%eax
80102d6f:	89 c2                	mov    %eax,%edx
80102d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d74:	83 c0 08             	add    $0x8,%eax
80102d77:	01 c0                	add    %eax,%eax
80102d79:	83 ec 08             	sub    $0x8,%esp
80102d7c:	52                   	push   %edx
80102d7d:	50                   	push   %eax
80102d7e:	e8 5c ff ff ff       	call   80102cdf <ioapicwrite>
80102d83:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d89:	83 c0 08             	add    $0x8,%eax
80102d8c:	01 c0                	add    %eax,%eax
80102d8e:	83 c0 01             	add    $0x1,%eax
80102d91:	83 ec 08             	sub    $0x8,%esp
80102d94:	6a 00                	push   $0x0
80102d96:	50                   	push   %eax
80102d97:	e8 43 ff ff ff       	call   80102cdf <ioapicwrite>
80102d9c:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102d9f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102da6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102da9:	7e b9                	jle    80102d64 <ioapicinit+0x6a>
80102dab:	eb 01                	jmp    80102dae <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102dad:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102dae:	c9                   	leave  
80102daf:	c3                   	ret    

80102db0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102db3:	a1 64 36 11 80       	mov    0x80113664,%eax
80102db8:	85 c0                	test   %eax,%eax
80102dba:	74 39                	je     80102df5 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102dbc:	8b 45 08             	mov    0x8(%ebp),%eax
80102dbf:	83 c0 20             	add    $0x20,%eax
80102dc2:	89 c2                	mov    %eax,%edx
80102dc4:	8b 45 08             	mov    0x8(%ebp),%eax
80102dc7:	83 c0 08             	add    $0x8,%eax
80102dca:	01 c0                	add    %eax,%eax
80102dcc:	52                   	push   %edx
80102dcd:	50                   	push   %eax
80102dce:	e8 0c ff ff ff       	call   80102cdf <ioapicwrite>
80102dd3:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dd9:	c1 e0 18             	shl    $0x18,%eax
80102ddc:	89 c2                	mov    %eax,%edx
80102dde:	8b 45 08             	mov    0x8(%ebp),%eax
80102de1:	83 c0 08             	add    $0x8,%eax
80102de4:	01 c0                	add    %eax,%eax
80102de6:	83 c0 01             	add    $0x1,%eax
80102de9:	52                   	push   %edx
80102dea:	50                   	push   %eax
80102deb:	e8 ef fe ff ff       	call   80102cdf <ioapicwrite>
80102df0:	83 c4 08             	add    $0x8,%esp
80102df3:	eb 01                	jmp    80102df6 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102df5:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102df6:	c9                   	leave  
80102df7:	c3                   	ret    

80102df8 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102df8:	55                   	push   %ebp
80102df9:	89 e5                	mov    %esp,%ebp
80102dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80102dfe:	05 00 00 00 80       	add    $0x80000000,%eax
80102e03:	5d                   	pop    %ebp
80102e04:	c3                   	ret    

80102e05 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102e05:	55                   	push   %ebp
80102e06:	89 e5                	mov    %esp,%ebp
80102e08:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102e0b:	83 ec 08             	sub    $0x8,%esp
80102e0e:	68 d2 8f 10 80       	push   $0x80108fd2
80102e13:	68 40 35 11 80       	push   $0x80113540
80102e18:	e8 ab 24 00 00       	call   801052c8 <initlock>
80102e1d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e20:	c7 05 74 35 11 80 00 	movl   $0x0,0x80113574
80102e27:	00 00 00 
  freerange(vstart, vend);
80102e2a:	83 ec 08             	sub    $0x8,%esp
80102e2d:	ff 75 0c             	pushl  0xc(%ebp)
80102e30:	ff 75 08             	pushl  0x8(%ebp)
80102e33:	e8 2a 00 00 00       	call   80102e62 <freerange>
80102e38:	83 c4 10             	add    $0x10,%esp
}
80102e3b:	90                   	nop
80102e3c:	c9                   	leave  
80102e3d:	c3                   	ret    

80102e3e <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102e3e:	55                   	push   %ebp
80102e3f:	89 e5                	mov    %esp,%ebp
80102e41:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102e44:	83 ec 08             	sub    $0x8,%esp
80102e47:	ff 75 0c             	pushl  0xc(%ebp)
80102e4a:	ff 75 08             	pushl  0x8(%ebp)
80102e4d:	e8 10 00 00 00       	call   80102e62 <freerange>
80102e52:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102e55:	c7 05 74 35 11 80 01 	movl   $0x1,0x80113574
80102e5c:	00 00 00 
}
80102e5f:	90                   	nop
80102e60:	c9                   	leave  
80102e61:	c3                   	ret    

80102e62 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102e62:	55                   	push   %ebp
80102e63:	89 e5                	mov    %esp,%ebp
80102e65:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102e68:	8b 45 08             	mov    0x8(%ebp),%eax
80102e6b:	05 ff 0f 00 00       	add    $0xfff,%eax
80102e70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e78:	eb 15                	jmp    80102e8f <freerange+0x2d>
    kfree(p);
80102e7a:	83 ec 0c             	sub    $0xc,%esp
80102e7d:	ff 75 f4             	pushl  -0xc(%ebp)
80102e80:	e8 1a 00 00 00       	call   80102e9f <kfree>
80102e85:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e88:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e92:	05 00 10 00 00       	add    $0x1000,%eax
80102e97:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102e9a:	76 de                	jbe    80102e7a <freerange+0x18>
    kfree(p);
}
80102e9c:	90                   	nop
80102e9d:	c9                   	leave  
80102e9e:	c3                   	ret    

80102e9f <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102e9f:	55                   	push   %ebp
80102ea0:	89 e5                	mov    %esp,%ebp
80102ea2:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80102ea8:	25 ff 0f 00 00       	and    $0xfff,%eax
80102ead:	85 c0                	test   %eax,%eax
80102eaf:	75 1b                	jne    80102ecc <kfree+0x2d>
80102eb1:	81 7d 08 5c 66 11 80 	cmpl   $0x8011665c,0x8(%ebp)
80102eb8:	72 12                	jb     80102ecc <kfree+0x2d>
80102eba:	ff 75 08             	pushl  0x8(%ebp)
80102ebd:	e8 36 ff ff ff       	call   80102df8 <v2p>
80102ec2:	83 c4 04             	add    $0x4,%esp
80102ec5:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102eca:	76 0d                	jbe    80102ed9 <kfree+0x3a>
    panic("kfree");
80102ecc:	83 ec 0c             	sub    $0xc,%esp
80102ecf:	68 d7 8f 10 80       	push   $0x80108fd7
80102ed4:	e8 8d d6 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ed9:	83 ec 04             	sub    $0x4,%esp
80102edc:	68 00 10 00 00       	push   $0x1000
80102ee1:	6a 01                	push   $0x1
80102ee3:	ff 75 08             	pushl  0x8(%ebp)
80102ee6:	e8 62 26 00 00       	call   8010554d <memset>
80102eeb:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102eee:	a1 74 35 11 80       	mov    0x80113574,%eax
80102ef3:	85 c0                	test   %eax,%eax
80102ef5:	74 10                	je     80102f07 <kfree+0x68>
    acquire(&kmem.lock);
80102ef7:	83 ec 0c             	sub    $0xc,%esp
80102efa:	68 40 35 11 80       	push   $0x80113540
80102eff:	e8 e6 23 00 00       	call   801052ea <acquire>
80102f04:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102f07:	8b 45 08             	mov    0x8(%ebp),%eax
80102f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102f0d:	8b 15 78 35 11 80    	mov    0x80113578,%edx
80102f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f16:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f1b:	a3 78 35 11 80       	mov    %eax,0x80113578
  if(kmem.use_lock)
80102f20:	a1 74 35 11 80       	mov    0x80113574,%eax
80102f25:	85 c0                	test   %eax,%eax
80102f27:	74 10                	je     80102f39 <kfree+0x9a>
    release(&kmem.lock);
80102f29:	83 ec 0c             	sub    $0xc,%esp
80102f2c:	68 40 35 11 80       	push   $0x80113540
80102f31:	e8 1b 24 00 00       	call   80105351 <release>
80102f36:	83 c4 10             	add    $0x10,%esp
}
80102f39:	90                   	nop
80102f3a:	c9                   	leave  
80102f3b:	c3                   	ret    

80102f3c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102f3c:	55                   	push   %ebp
80102f3d:	89 e5                	mov    %esp,%ebp
80102f3f:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102f42:	a1 74 35 11 80       	mov    0x80113574,%eax
80102f47:	85 c0                	test   %eax,%eax
80102f49:	74 10                	je     80102f5b <kalloc+0x1f>
    acquire(&kmem.lock);
80102f4b:	83 ec 0c             	sub    $0xc,%esp
80102f4e:	68 40 35 11 80       	push   $0x80113540
80102f53:	e8 92 23 00 00       	call   801052ea <acquire>
80102f58:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102f5b:	a1 78 35 11 80       	mov    0x80113578,%eax
80102f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102f63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102f67:	74 0a                	je     80102f73 <kalloc+0x37>
    kmem.freelist = r->next;
80102f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f6c:	8b 00                	mov    (%eax),%eax
80102f6e:	a3 78 35 11 80       	mov    %eax,0x80113578
  if(kmem.use_lock)
80102f73:	a1 74 35 11 80       	mov    0x80113574,%eax
80102f78:	85 c0                	test   %eax,%eax
80102f7a:	74 10                	je     80102f8c <kalloc+0x50>
    release(&kmem.lock);
80102f7c:	83 ec 0c             	sub    $0xc,%esp
80102f7f:	68 40 35 11 80       	push   $0x80113540
80102f84:	e8 c8 23 00 00       	call   80105351 <release>
80102f89:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102f8f:	c9                   	leave  
80102f90:	c3                   	ret    

80102f91 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102f91:	55                   	push   %ebp
80102f92:	89 e5                	mov    %esp,%ebp
80102f94:	83 ec 14             	sub    $0x14,%esp
80102f97:	8b 45 08             	mov    0x8(%ebp),%eax
80102f9a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f9e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102fa2:	89 c2                	mov    %eax,%edx
80102fa4:	ec                   	in     (%dx),%al
80102fa5:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102fa8:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102fac:	c9                   	leave  
80102fad:	c3                   	ret    

80102fae <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102fae:	55                   	push   %ebp
80102faf:	89 e5                	mov    %esp,%ebp
80102fb1:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102fb4:	6a 64                	push   $0x64
80102fb6:	e8 d6 ff ff ff       	call   80102f91 <inb>
80102fbb:	83 c4 04             	add    $0x4,%esp
80102fbe:	0f b6 c0             	movzbl %al,%eax
80102fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fc7:	83 e0 01             	and    $0x1,%eax
80102fca:	85 c0                	test   %eax,%eax
80102fcc:	75 0a                	jne    80102fd8 <kbdgetc+0x2a>
    return -1;
80102fce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102fd3:	e9 23 01 00 00       	jmp    801030fb <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102fd8:	6a 60                	push   $0x60
80102fda:	e8 b2 ff ff ff       	call   80102f91 <inb>
80102fdf:	83 c4 04             	add    $0x4,%esp
80102fe2:	0f b6 c0             	movzbl %al,%eax
80102fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102fe8:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102fef:	75 17                	jne    80103008 <kbdgetc+0x5a>
    shift |= E0ESC;
80102ff1:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ff6:	83 c8 40             	or     $0x40,%eax
80102ff9:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80102ffe:	b8 00 00 00 00       	mov    $0x0,%eax
80103003:	e9 f3 00 00 00       	jmp    801030fb <kbdgetc+0x14d>
  } else if(data & 0x80){
80103008:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010300b:	25 80 00 00 00       	and    $0x80,%eax
80103010:	85 c0                	test   %eax,%eax
80103012:	74 45                	je     80103059 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103014:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80103019:	83 e0 40             	and    $0x40,%eax
8010301c:	85 c0                	test   %eax,%eax
8010301e:	75 08                	jne    80103028 <kbdgetc+0x7a>
80103020:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103023:	83 e0 7f             	and    $0x7f,%eax
80103026:	eb 03                	jmp    8010302b <kbdgetc+0x7d>
80103028:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010302b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
8010302e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103031:	05 20 a0 10 80       	add    $0x8010a020,%eax
80103036:	0f b6 00             	movzbl (%eax),%eax
80103039:	83 c8 40             	or     $0x40,%eax
8010303c:	0f b6 c0             	movzbl %al,%eax
8010303f:	f7 d0                	not    %eax
80103041:	89 c2                	mov    %eax,%edx
80103043:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80103048:	21 d0                	and    %edx,%eax
8010304a:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
8010304f:	b8 00 00 00 00       	mov    $0x0,%eax
80103054:	e9 a2 00 00 00       	jmp    801030fb <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80103059:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
8010305e:	83 e0 40             	and    $0x40,%eax
80103061:	85 c0                	test   %eax,%eax
80103063:	74 14                	je     80103079 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103065:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
8010306c:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80103071:	83 e0 bf             	and    $0xffffffbf,%eax
80103074:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  }

  shift |= shiftcode[data];
80103079:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010307c:	05 20 a0 10 80       	add    $0x8010a020,%eax
80103081:	0f b6 00             	movzbl (%eax),%eax
80103084:	0f b6 d0             	movzbl %al,%edx
80103087:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
8010308c:	09 d0                	or     %edx,%eax
8010308e:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  shift ^= togglecode[data];
80103093:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103096:	05 20 a1 10 80       	add    $0x8010a120,%eax
8010309b:	0f b6 00             	movzbl (%eax),%eax
8010309e:	0f b6 d0             	movzbl %al,%edx
801030a1:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
801030a6:	31 d0                	xor    %edx,%eax
801030a8:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  c = charcode[shift & (CTL | SHIFT)][data];
801030ad:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
801030b2:	83 e0 03             	and    $0x3,%eax
801030b5:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
801030bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030bf:	01 d0                	add    %edx,%eax
801030c1:	0f b6 00             	movzbl (%eax),%eax
801030c4:	0f b6 c0             	movzbl %al,%eax
801030c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
801030ca:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
801030cf:	83 e0 08             	and    $0x8,%eax
801030d2:	85 c0                	test   %eax,%eax
801030d4:	74 22                	je     801030f8 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
801030d6:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
801030da:	76 0c                	jbe    801030e8 <kbdgetc+0x13a>
801030dc:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
801030e0:	77 06                	ja     801030e8 <kbdgetc+0x13a>
      c += 'A' - 'a';
801030e2:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
801030e6:	eb 10                	jmp    801030f8 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
801030e8:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
801030ec:	76 0a                	jbe    801030f8 <kbdgetc+0x14a>
801030ee:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
801030f2:	77 04                	ja     801030f8 <kbdgetc+0x14a>
      c += 'a' - 'A';
801030f4:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
801030f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801030fb:	c9                   	leave  
801030fc:	c3                   	ret    

801030fd <kbdintr>:

void
kbdintr(void)
{
801030fd:	55                   	push   %ebp
801030fe:	89 e5                	mov    %esp,%ebp
80103100:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80103103:	83 ec 0c             	sub    $0xc,%esp
80103106:	68 ae 2f 10 80       	push   $0x80102fae
8010310b:	e8 cd d6 ff ff       	call   801007dd <consoleintr>
80103110:	83 c4 10             	add    $0x10,%esp
}
80103113:	90                   	nop
80103114:	c9                   	leave  
80103115:	c3                   	ret    

80103116 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103116:	55                   	push   %ebp
80103117:	89 e5                	mov    %esp,%ebp
80103119:	83 ec 14             	sub    $0x14,%esp
8010311c:	8b 45 08             	mov    0x8(%ebp),%eax
8010311f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103123:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103127:	89 c2                	mov    %eax,%edx
80103129:	ec                   	in     (%dx),%al
8010312a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010312d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103131:	c9                   	leave  
80103132:	c3                   	ret    

80103133 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103133:	55                   	push   %ebp
80103134:	89 e5                	mov    %esp,%ebp
80103136:	83 ec 08             	sub    $0x8,%esp
80103139:	8b 55 08             	mov    0x8(%ebp),%edx
8010313c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010313f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103143:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103146:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010314a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010314e:	ee                   	out    %al,(%dx)
}
8010314f:	90                   	nop
80103150:	c9                   	leave  
80103151:	c3                   	ret    

80103152 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103152:	55                   	push   %ebp
80103153:	89 e5                	mov    %esp,%ebp
80103155:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103158:	9c                   	pushf  
80103159:	58                   	pop    %eax
8010315a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010315d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103160:	c9                   	leave  
80103161:	c3                   	ret    

80103162 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80103162:	55                   	push   %ebp
80103163:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103165:	a1 7c 35 11 80       	mov    0x8011357c,%eax
8010316a:	8b 55 08             	mov    0x8(%ebp),%edx
8010316d:	c1 e2 02             	shl    $0x2,%edx
80103170:	01 c2                	add    %eax,%edx
80103172:	8b 45 0c             	mov    0xc(%ebp),%eax
80103175:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80103177:	a1 7c 35 11 80       	mov    0x8011357c,%eax
8010317c:	83 c0 20             	add    $0x20,%eax
8010317f:	8b 00                	mov    (%eax),%eax
}
80103181:	90                   	nop
80103182:	5d                   	pop    %ebp
80103183:	c3                   	ret    

80103184 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80103184:	55                   	push   %ebp
80103185:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80103187:	a1 7c 35 11 80       	mov    0x8011357c,%eax
8010318c:	85 c0                	test   %eax,%eax
8010318e:	0f 84 0b 01 00 00    	je     8010329f <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103194:	68 3f 01 00 00       	push   $0x13f
80103199:	6a 3c                	push   $0x3c
8010319b:	e8 c2 ff ff ff       	call   80103162 <lapicw>
801031a0:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801031a3:	6a 0b                	push   $0xb
801031a5:	68 f8 00 00 00       	push   $0xf8
801031aa:	e8 b3 ff ff ff       	call   80103162 <lapicw>
801031af:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801031b2:	68 20 00 02 00       	push   $0x20020
801031b7:	68 c8 00 00 00       	push   $0xc8
801031bc:	e8 a1 ff ff ff       	call   80103162 <lapicw>
801031c1:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
801031c4:	68 80 96 98 00       	push   $0x989680
801031c9:	68 e0 00 00 00       	push   $0xe0
801031ce:	e8 8f ff ff ff       	call   80103162 <lapicw>
801031d3:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801031d6:	68 00 00 01 00       	push   $0x10000
801031db:	68 d4 00 00 00       	push   $0xd4
801031e0:	e8 7d ff ff ff       	call   80103162 <lapicw>
801031e5:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
801031e8:	68 00 00 01 00       	push   $0x10000
801031ed:	68 d8 00 00 00       	push   $0xd8
801031f2:	e8 6b ff ff ff       	call   80103162 <lapicw>
801031f7:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801031fa:	a1 7c 35 11 80       	mov    0x8011357c,%eax
801031ff:	83 c0 30             	add    $0x30,%eax
80103202:	8b 00                	mov    (%eax),%eax
80103204:	c1 e8 10             	shr    $0x10,%eax
80103207:	0f b6 c0             	movzbl %al,%eax
8010320a:	83 f8 03             	cmp    $0x3,%eax
8010320d:	76 12                	jbe    80103221 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
8010320f:	68 00 00 01 00       	push   $0x10000
80103214:	68 d0 00 00 00       	push   $0xd0
80103219:	e8 44 ff ff ff       	call   80103162 <lapicw>
8010321e:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103221:	6a 33                	push   $0x33
80103223:	68 dc 00 00 00       	push   $0xdc
80103228:	e8 35 ff ff ff       	call   80103162 <lapicw>
8010322d:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103230:	6a 00                	push   $0x0
80103232:	68 a0 00 00 00       	push   $0xa0
80103237:	e8 26 ff ff ff       	call   80103162 <lapicw>
8010323c:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
8010323f:	6a 00                	push   $0x0
80103241:	68 a0 00 00 00       	push   $0xa0
80103246:	e8 17 ff ff ff       	call   80103162 <lapicw>
8010324b:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
8010324e:	6a 00                	push   $0x0
80103250:	6a 2c                	push   $0x2c
80103252:	e8 0b ff ff ff       	call   80103162 <lapicw>
80103257:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010325a:	6a 00                	push   $0x0
8010325c:	68 c4 00 00 00       	push   $0xc4
80103261:	e8 fc fe ff ff       	call   80103162 <lapicw>
80103266:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103269:	68 00 85 08 00       	push   $0x88500
8010326e:	68 c0 00 00 00       	push   $0xc0
80103273:	e8 ea fe ff ff       	call   80103162 <lapicw>
80103278:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
8010327b:	90                   	nop
8010327c:	a1 7c 35 11 80       	mov    0x8011357c,%eax
80103281:	05 00 03 00 00       	add    $0x300,%eax
80103286:	8b 00                	mov    (%eax),%eax
80103288:	25 00 10 00 00       	and    $0x1000,%eax
8010328d:	85 c0                	test   %eax,%eax
8010328f:	75 eb                	jne    8010327c <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103291:	6a 00                	push   $0x0
80103293:	6a 20                	push   $0x20
80103295:	e8 c8 fe ff ff       	call   80103162 <lapicw>
8010329a:	83 c4 08             	add    $0x8,%esp
8010329d:	eb 01                	jmp    801032a0 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
8010329f:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801032a0:	c9                   	leave  
801032a1:	c3                   	ret    

801032a2 <cpunum>:

int
cpunum(void)
{
801032a2:	55                   	push   %ebp
801032a3:	89 e5                	mov    %esp,%ebp
801032a5:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801032a8:	e8 a5 fe ff ff       	call   80103152 <readeflags>
801032ad:	25 00 02 00 00       	and    $0x200,%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 26                	je     801032dc <cpunum+0x3a>
    static int n;
    if(n++ == 0)
801032b6:	a1 80 c6 10 80       	mov    0x8010c680,%eax
801032bb:	8d 50 01             	lea    0x1(%eax),%edx
801032be:	89 15 80 c6 10 80    	mov    %edx,0x8010c680
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 14                	jne    801032dc <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
801032c8:	8b 45 04             	mov    0x4(%ebp),%eax
801032cb:	83 ec 08             	sub    $0x8,%esp
801032ce:	50                   	push   %eax
801032cf:	68 e0 8f 10 80       	push   $0x80108fe0
801032d4:	e8 ed d0 ff ff       	call   801003c6 <cprintf>
801032d9:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801032dc:	a1 7c 35 11 80       	mov    0x8011357c,%eax
801032e1:	85 c0                	test   %eax,%eax
801032e3:	74 0f                	je     801032f4 <cpunum+0x52>
    return lapic[ID]>>24;
801032e5:	a1 7c 35 11 80       	mov    0x8011357c,%eax
801032ea:	83 c0 20             	add    $0x20,%eax
801032ed:	8b 00                	mov    (%eax),%eax
801032ef:	c1 e8 18             	shr    $0x18,%eax
801032f2:	eb 05                	jmp    801032f9 <cpunum+0x57>
  return 0;
801032f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801032f9:	c9                   	leave  
801032fa:	c3                   	ret    

801032fb <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801032fb:	55                   	push   %ebp
801032fc:	89 e5                	mov    %esp,%ebp
  if(lapic)
801032fe:	a1 7c 35 11 80       	mov    0x8011357c,%eax
80103303:	85 c0                	test   %eax,%eax
80103305:	74 0c                	je     80103313 <lapiceoi+0x18>
    lapicw(EOI, 0);
80103307:	6a 00                	push   $0x0
80103309:	6a 2c                	push   $0x2c
8010330b:	e8 52 fe ff ff       	call   80103162 <lapicw>
80103310:	83 c4 08             	add    $0x8,%esp
}
80103313:	90                   	nop
80103314:	c9                   	leave  
80103315:	c3                   	ret    

80103316 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103316:	55                   	push   %ebp
80103317:	89 e5                	mov    %esp,%ebp
}
80103319:	90                   	nop
8010331a:	5d                   	pop    %ebp
8010331b:	c3                   	ret    

8010331c <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010331c:	55                   	push   %ebp
8010331d:	89 e5                	mov    %esp,%ebp
8010331f:	83 ec 14             	sub    $0x14,%esp
80103322:	8b 45 08             	mov    0x8(%ebp),%eax
80103325:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103328:	6a 0f                	push   $0xf
8010332a:	6a 70                	push   $0x70
8010332c:	e8 02 fe ff ff       	call   80103133 <outb>
80103331:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103334:	6a 0a                	push   $0xa
80103336:	6a 71                	push   $0x71
80103338:	e8 f6 fd ff ff       	call   80103133 <outb>
8010333d:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103340:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103347:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010334a:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010334f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103352:	83 c0 02             	add    $0x2,%eax
80103355:	8b 55 0c             	mov    0xc(%ebp),%edx
80103358:	c1 ea 04             	shr    $0x4,%edx
8010335b:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010335e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103362:	c1 e0 18             	shl    $0x18,%eax
80103365:	50                   	push   %eax
80103366:	68 c4 00 00 00       	push   $0xc4
8010336b:	e8 f2 fd ff ff       	call   80103162 <lapicw>
80103370:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103373:	68 00 c5 00 00       	push   $0xc500
80103378:	68 c0 00 00 00       	push   $0xc0
8010337d:	e8 e0 fd ff ff       	call   80103162 <lapicw>
80103382:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103385:	68 c8 00 00 00       	push   $0xc8
8010338a:	e8 87 ff ff ff       	call   80103316 <microdelay>
8010338f:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103392:	68 00 85 00 00       	push   $0x8500
80103397:	68 c0 00 00 00       	push   $0xc0
8010339c:	e8 c1 fd ff ff       	call   80103162 <lapicw>
801033a1:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801033a4:	6a 64                	push   $0x64
801033a6:	e8 6b ff ff ff       	call   80103316 <microdelay>
801033ab:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801033ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801033b5:	eb 3d                	jmp    801033f4 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
801033b7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801033bb:	c1 e0 18             	shl    $0x18,%eax
801033be:	50                   	push   %eax
801033bf:	68 c4 00 00 00       	push   $0xc4
801033c4:	e8 99 fd ff ff       	call   80103162 <lapicw>
801033c9:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801033cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801033cf:	c1 e8 0c             	shr    $0xc,%eax
801033d2:	80 cc 06             	or     $0x6,%ah
801033d5:	50                   	push   %eax
801033d6:	68 c0 00 00 00       	push   $0xc0
801033db:	e8 82 fd ff ff       	call   80103162 <lapicw>
801033e0:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801033e3:	68 c8 00 00 00       	push   $0xc8
801033e8:	e8 29 ff ff ff       	call   80103316 <microdelay>
801033ed:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801033f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801033f4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801033f8:	7e bd                	jle    801033b7 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801033fa:	90                   	nop
801033fb:	c9                   	leave  
801033fc:	c3                   	ret    

801033fd <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801033fd:	55                   	push   %ebp
801033fe:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103400:	8b 45 08             	mov    0x8(%ebp),%eax
80103403:	0f b6 c0             	movzbl %al,%eax
80103406:	50                   	push   %eax
80103407:	6a 70                	push   $0x70
80103409:	e8 25 fd ff ff       	call   80103133 <outb>
8010340e:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103411:	68 c8 00 00 00       	push   $0xc8
80103416:	e8 fb fe ff ff       	call   80103316 <microdelay>
8010341b:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010341e:	6a 71                	push   $0x71
80103420:	e8 f1 fc ff ff       	call   80103116 <inb>
80103425:	83 c4 04             	add    $0x4,%esp
80103428:	0f b6 c0             	movzbl %al,%eax
}
8010342b:	c9                   	leave  
8010342c:	c3                   	ret    

8010342d <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010342d:	55                   	push   %ebp
8010342e:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103430:	6a 00                	push   $0x0
80103432:	e8 c6 ff ff ff       	call   801033fd <cmos_read>
80103437:	83 c4 04             	add    $0x4,%esp
8010343a:	89 c2                	mov    %eax,%edx
8010343c:	8b 45 08             	mov    0x8(%ebp),%eax
8010343f:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103441:	6a 02                	push   $0x2
80103443:	e8 b5 ff ff ff       	call   801033fd <cmos_read>
80103448:	83 c4 04             	add    $0x4,%esp
8010344b:	89 c2                	mov    %eax,%edx
8010344d:	8b 45 08             	mov    0x8(%ebp),%eax
80103450:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103453:	6a 04                	push   $0x4
80103455:	e8 a3 ff ff ff       	call   801033fd <cmos_read>
8010345a:	83 c4 04             	add    $0x4,%esp
8010345d:	89 c2                	mov    %eax,%edx
8010345f:	8b 45 08             	mov    0x8(%ebp),%eax
80103462:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103465:	6a 07                	push   $0x7
80103467:	e8 91 ff ff ff       	call   801033fd <cmos_read>
8010346c:	83 c4 04             	add    $0x4,%esp
8010346f:	89 c2                	mov    %eax,%edx
80103471:	8b 45 08             	mov    0x8(%ebp),%eax
80103474:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103477:	6a 08                	push   $0x8
80103479:	e8 7f ff ff ff       	call   801033fd <cmos_read>
8010347e:	83 c4 04             	add    $0x4,%esp
80103481:	89 c2                	mov    %eax,%edx
80103483:	8b 45 08             	mov    0x8(%ebp),%eax
80103486:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103489:	6a 09                	push   $0x9
8010348b:	e8 6d ff ff ff       	call   801033fd <cmos_read>
80103490:	83 c4 04             	add    $0x4,%esp
80103493:	89 c2                	mov    %eax,%edx
80103495:	8b 45 08             	mov    0x8(%ebp),%eax
80103498:	89 50 14             	mov    %edx,0x14(%eax)
}
8010349b:	90                   	nop
8010349c:	c9                   	leave  
8010349d:	c3                   	ret    

8010349e <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010349e:	55                   	push   %ebp
8010349f:	89 e5                	mov    %esp,%ebp
801034a1:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801034a4:	6a 0b                	push   $0xb
801034a6:	e8 52 ff ff ff       	call   801033fd <cmos_read>
801034ab:	83 c4 04             	add    $0x4,%esp
801034ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034b4:	83 e0 04             	and    $0x4,%eax
801034b7:	85 c0                	test   %eax,%eax
801034b9:	0f 94 c0             	sete   %al
801034bc:	0f b6 c0             	movzbl %al,%eax
801034bf:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801034c2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801034c5:	50                   	push   %eax
801034c6:	e8 62 ff ff ff       	call   8010342d <fill_rtcdate>
801034cb:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801034ce:	6a 0a                	push   $0xa
801034d0:	e8 28 ff ff ff       	call   801033fd <cmos_read>
801034d5:	83 c4 04             	add    $0x4,%esp
801034d8:	25 80 00 00 00       	and    $0x80,%eax
801034dd:	85 c0                	test   %eax,%eax
801034df:	75 27                	jne    80103508 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801034e1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801034e4:	50                   	push   %eax
801034e5:	e8 43 ff ff ff       	call   8010342d <fill_rtcdate>
801034ea:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801034ed:	83 ec 04             	sub    $0x4,%esp
801034f0:	6a 18                	push   $0x18
801034f2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801034f5:	50                   	push   %eax
801034f6:	8d 45 d8             	lea    -0x28(%ebp),%eax
801034f9:	50                   	push   %eax
801034fa:	e8 b5 20 00 00       	call   801055b4 <memcmp>
801034ff:	83 c4 10             	add    $0x10,%esp
80103502:	85 c0                	test   %eax,%eax
80103504:	74 05                	je     8010350b <cmostime+0x6d>
80103506:	eb ba                	jmp    801034c2 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103508:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103509:	eb b7                	jmp    801034c2 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010350b:	90                   	nop
  }

  // convert
  if (bcd) {
8010350c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103510:	0f 84 b4 00 00 00    	je     801035ca <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103516:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103519:	c1 e8 04             	shr    $0x4,%eax
8010351c:	89 c2                	mov    %eax,%edx
8010351e:	89 d0                	mov    %edx,%eax
80103520:	c1 e0 02             	shl    $0x2,%eax
80103523:	01 d0                	add    %edx,%eax
80103525:	01 c0                	add    %eax,%eax
80103527:	89 c2                	mov    %eax,%edx
80103529:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010352c:	83 e0 0f             	and    $0xf,%eax
8010352f:	01 d0                	add    %edx,%eax
80103531:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103534:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103537:	c1 e8 04             	shr    $0x4,%eax
8010353a:	89 c2                	mov    %eax,%edx
8010353c:	89 d0                	mov    %edx,%eax
8010353e:	c1 e0 02             	shl    $0x2,%eax
80103541:	01 d0                	add    %edx,%eax
80103543:	01 c0                	add    %eax,%eax
80103545:	89 c2                	mov    %eax,%edx
80103547:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010354a:	83 e0 0f             	and    $0xf,%eax
8010354d:	01 d0                	add    %edx,%eax
8010354f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103552:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103555:	c1 e8 04             	shr    $0x4,%eax
80103558:	89 c2                	mov    %eax,%edx
8010355a:	89 d0                	mov    %edx,%eax
8010355c:	c1 e0 02             	shl    $0x2,%eax
8010355f:	01 d0                	add    %edx,%eax
80103561:	01 c0                	add    %eax,%eax
80103563:	89 c2                	mov    %eax,%edx
80103565:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103568:	83 e0 0f             	and    $0xf,%eax
8010356b:	01 d0                	add    %edx,%eax
8010356d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103573:	c1 e8 04             	shr    $0x4,%eax
80103576:	89 c2                	mov    %eax,%edx
80103578:	89 d0                	mov    %edx,%eax
8010357a:	c1 e0 02             	shl    $0x2,%eax
8010357d:	01 d0                	add    %edx,%eax
8010357f:	01 c0                	add    %eax,%eax
80103581:	89 c2                	mov    %eax,%edx
80103583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103586:	83 e0 0f             	and    $0xf,%eax
80103589:	01 d0                	add    %edx,%eax
8010358b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010358e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103591:	c1 e8 04             	shr    $0x4,%eax
80103594:	89 c2                	mov    %eax,%edx
80103596:	89 d0                	mov    %edx,%eax
80103598:	c1 e0 02             	shl    $0x2,%eax
8010359b:	01 d0                	add    %edx,%eax
8010359d:	01 c0                	add    %eax,%eax
8010359f:	89 c2                	mov    %eax,%edx
801035a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801035a4:	83 e0 0f             	and    $0xf,%eax
801035a7:	01 d0                	add    %edx,%eax
801035a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801035ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035af:	c1 e8 04             	shr    $0x4,%eax
801035b2:	89 c2                	mov    %eax,%edx
801035b4:	89 d0                	mov    %edx,%eax
801035b6:	c1 e0 02             	shl    $0x2,%eax
801035b9:	01 d0                	add    %edx,%eax
801035bb:	01 c0                	add    %eax,%eax
801035bd:	89 c2                	mov    %eax,%edx
801035bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035c2:	83 e0 0f             	and    $0xf,%eax
801035c5:	01 d0                	add    %edx,%eax
801035c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801035ca:	8b 45 08             	mov    0x8(%ebp),%eax
801035cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
801035d0:	89 10                	mov    %edx,(%eax)
801035d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801035d5:	89 50 04             	mov    %edx,0x4(%eax)
801035d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801035db:	89 50 08             	mov    %edx,0x8(%eax)
801035de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801035e1:	89 50 0c             	mov    %edx,0xc(%eax)
801035e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801035e7:	89 50 10             	mov    %edx,0x10(%eax)
801035ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
801035ed:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801035f0:	8b 45 08             	mov    0x8(%ebp),%eax
801035f3:	8b 40 14             	mov    0x14(%eax),%eax
801035f6:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801035fc:	8b 45 08             	mov    0x8(%ebp),%eax
801035ff:	89 50 14             	mov    %edx,0x14(%eax)
}
80103602:	90                   	nop
80103603:	c9                   	leave  
80103604:	c3                   	ret    

80103605 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103605:	55                   	push   %ebp
80103606:	89 e5                	mov    %esp,%ebp
80103608:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010360b:	83 ec 08             	sub    $0x8,%esp
8010360e:	68 0c 90 10 80       	push   $0x8010900c
80103613:	68 80 35 11 80       	push   $0x80113580
80103618:	e8 ab 1c 00 00       	call   801052c8 <initlock>
8010361d:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103620:	83 ec 08             	sub    $0x8,%esp
80103623:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103626:	50                   	push   %eax
80103627:	ff 75 08             	pushl  0x8(%ebp)
8010362a:	e8 2b e0 ff ff       	call   8010165a <readsb>
8010362f:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103632:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103635:	a3 b4 35 11 80       	mov    %eax,0x801135b4
  log.size = sb.nlog;
8010363a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010363d:	a3 b8 35 11 80       	mov    %eax,0x801135b8
  log.dev = dev;
80103642:	8b 45 08             	mov    0x8(%ebp),%eax
80103645:	a3 c4 35 11 80       	mov    %eax,0x801135c4
  recover_from_log();
8010364a:	e8 b2 01 00 00       	call   80103801 <recover_from_log>
}
8010364f:	90                   	nop
80103650:	c9                   	leave  
80103651:	c3                   	ret    

80103652 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103652:	55                   	push   %ebp
80103653:	89 e5                	mov    %esp,%ebp
80103655:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103658:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010365f:	e9 95 00 00 00       	jmp    801036f9 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103664:	8b 15 b4 35 11 80    	mov    0x801135b4,%edx
8010366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010366d:	01 d0                	add    %edx,%eax
8010366f:	83 c0 01             	add    $0x1,%eax
80103672:	89 c2                	mov    %eax,%edx
80103674:	a1 c4 35 11 80       	mov    0x801135c4,%eax
80103679:	83 ec 08             	sub    $0x8,%esp
8010367c:	52                   	push   %edx
8010367d:	50                   	push   %eax
8010367e:	e8 33 cb ff ff       	call   801001b6 <bread>
80103683:	83 c4 10             	add    $0x10,%esp
80103686:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010368c:	83 c0 10             	add    $0x10,%eax
8010368f:	8b 04 85 8c 35 11 80 	mov    -0x7feeca74(,%eax,4),%eax
80103696:	89 c2                	mov    %eax,%edx
80103698:	a1 c4 35 11 80       	mov    0x801135c4,%eax
8010369d:	83 ec 08             	sub    $0x8,%esp
801036a0:	52                   	push   %edx
801036a1:	50                   	push   %eax
801036a2:	e8 0f cb ff ff       	call   801001b6 <bread>
801036a7:	83 c4 10             	add    $0x10,%esp
801036aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801036ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b0:	8d 50 18             	lea    0x18(%eax),%edx
801036b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036b6:	83 c0 18             	add    $0x18,%eax
801036b9:	83 ec 04             	sub    $0x4,%esp
801036bc:	68 00 02 00 00       	push   $0x200
801036c1:	52                   	push   %edx
801036c2:	50                   	push   %eax
801036c3:	e8 44 1f 00 00       	call   8010560c <memmove>
801036c8:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801036cb:	83 ec 0c             	sub    $0xc,%esp
801036ce:	ff 75 ec             	pushl  -0x14(%ebp)
801036d1:	e8 19 cb ff ff       	call   801001ef <bwrite>
801036d6:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801036d9:	83 ec 0c             	sub    $0xc,%esp
801036dc:	ff 75 f0             	pushl  -0x10(%ebp)
801036df:	e8 4a cb ff ff       	call   8010022e <brelse>
801036e4:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801036e7:	83 ec 0c             	sub    $0xc,%esp
801036ea:	ff 75 ec             	pushl  -0x14(%ebp)
801036ed:	e8 3c cb ff ff       	call   8010022e <brelse>
801036f2:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036f9:	a1 c8 35 11 80       	mov    0x801135c8,%eax
801036fe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103701:	0f 8f 5d ff ff ff    	jg     80103664 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103707:	90                   	nop
80103708:	c9                   	leave  
80103709:	c3                   	ret    

8010370a <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010370a:	55                   	push   %ebp
8010370b:	89 e5                	mov    %esp,%ebp
8010370d:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103710:	a1 b4 35 11 80       	mov    0x801135b4,%eax
80103715:	89 c2                	mov    %eax,%edx
80103717:	a1 c4 35 11 80       	mov    0x801135c4,%eax
8010371c:	83 ec 08             	sub    $0x8,%esp
8010371f:	52                   	push   %edx
80103720:	50                   	push   %eax
80103721:	e8 90 ca ff ff       	call   801001b6 <bread>
80103726:	83 c4 10             	add    $0x10,%esp
80103729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010372c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010372f:	83 c0 18             	add    $0x18,%eax
80103732:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103735:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103738:	8b 00                	mov    (%eax),%eax
8010373a:	a3 c8 35 11 80       	mov    %eax,0x801135c8
  for (i = 0; i < log.lh.n; i++) {
8010373f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103746:	eb 1b                	jmp    80103763 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103748:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010374b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010374e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103752:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103755:	83 c2 10             	add    $0x10,%edx
80103758:	89 04 95 8c 35 11 80 	mov    %eax,-0x7feeca74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010375f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103763:	a1 c8 35 11 80       	mov    0x801135c8,%eax
80103768:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010376b:	7f db                	jg     80103748 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010376d:	83 ec 0c             	sub    $0xc,%esp
80103770:	ff 75 f0             	pushl  -0x10(%ebp)
80103773:	e8 b6 ca ff ff       	call   8010022e <brelse>
80103778:	83 c4 10             	add    $0x10,%esp
}
8010377b:	90                   	nop
8010377c:	c9                   	leave  
8010377d:	c3                   	ret    

8010377e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010377e:	55                   	push   %ebp
8010377f:	89 e5                	mov    %esp,%ebp
80103781:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103784:	a1 b4 35 11 80       	mov    0x801135b4,%eax
80103789:	89 c2                	mov    %eax,%edx
8010378b:	a1 c4 35 11 80       	mov    0x801135c4,%eax
80103790:	83 ec 08             	sub    $0x8,%esp
80103793:	52                   	push   %edx
80103794:	50                   	push   %eax
80103795:	e8 1c ca ff ff       	call   801001b6 <bread>
8010379a:	83 c4 10             	add    $0x10,%esp
8010379d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801037a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a3:	83 c0 18             	add    $0x18,%eax
801037a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801037a9:	8b 15 c8 35 11 80    	mov    0x801135c8,%edx
801037af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037b2:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801037b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037bb:	eb 1b                	jmp    801037d8 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801037bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c0:	83 c0 10             	add    $0x10,%eax
801037c3:	8b 0c 85 8c 35 11 80 	mov    -0x7feeca74(,%eax,4),%ecx
801037ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037d0:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801037d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037d8:	a1 c8 35 11 80       	mov    0x801135c8,%eax
801037dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037e0:	7f db                	jg     801037bd <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801037e2:	83 ec 0c             	sub    $0xc,%esp
801037e5:	ff 75 f0             	pushl  -0x10(%ebp)
801037e8:	e8 02 ca ff ff       	call   801001ef <bwrite>
801037ed:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801037f0:	83 ec 0c             	sub    $0xc,%esp
801037f3:	ff 75 f0             	pushl  -0x10(%ebp)
801037f6:	e8 33 ca ff ff       	call   8010022e <brelse>
801037fb:	83 c4 10             	add    $0x10,%esp
}
801037fe:	90                   	nop
801037ff:	c9                   	leave  
80103800:	c3                   	ret    

80103801 <recover_from_log>:

static void
recover_from_log(void)
{
80103801:	55                   	push   %ebp
80103802:	89 e5                	mov    %esp,%ebp
80103804:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103807:	e8 fe fe ff ff       	call   8010370a <read_head>
  install_trans(); // if committed, copy from log to disk
8010380c:	e8 41 fe ff ff       	call   80103652 <install_trans>
  log.lh.n = 0;
80103811:	c7 05 c8 35 11 80 00 	movl   $0x0,0x801135c8
80103818:	00 00 00 
  write_head(); // clear the log
8010381b:	e8 5e ff ff ff       	call   8010377e <write_head>
}
80103820:	90                   	nop
80103821:	c9                   	leave  
80103822:	c3                   	ret    

80103823 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103823:	55                   	push   %ebp
80103824:	89 e5                	mov    %esp,%ebp
80103826:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103829:	83 ec 0c             	sub    $0xc,%esp
8010382c:	68 80 35 11 80       	push   $0x80113580
80103831:	e8 b4 1a 00 00       	call   801052ea <acquire>
80103836:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103839:	a1 c0 35 11 80       	mov    0x801135c0,%eax
8010383e:	85 c0                	test   %eax,%eax
80103840:	74 17                	je     80103859 <begin_op+0x36>
      sleep(&log, &log.lock);
80103842:	83 ec 08             	sub    $0x8,%esp
80103845:	68 80 35 11 80       	push   $0x80113580
8010384a:	68 80 35 11 80       	push   $0x80113580
8010384f:	e8 94 17 00 00       	call   80104fe8 <sleep>
80103854:	83 c4 10             	add    $0x10,%esp
80103857:	eb e0                	jmp    80103839 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103859:	8b 0d c8 35 11 80    	mov    0x801135c8,%ecx
8010385f:	a1 bc 35 11 80       	mov    0x801135bc,%eax
80103864:	8d 50 01             	lea    0x1(%eax),%edx
80103867:	89 d0                	mov    %edx,%eax
80103869:	c1 e0 02             	shl    $0x2,%eax
8010386c:	01 d0                	add    %edx,%eax
8010386e:	01 c0                	add    %eax,%eax
80103870:	01 c8                	add    %ecx,%eax
80103872:	83 f8 1e             	cmp    $0x1e,%eax
80103875:	7e 17                	jle    8010388e <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103877:	83 ec 08             	sub    $0x8,%esp
8010387a:	68 80 35 11 80       	push   $0x80113580
8010387f:	68 80 35 11 80       	push   $0x80113580
80103884:	e8 5f 17 00 00       	call   80104fe8 <sleep>
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	eb ab                	jmp    80103839 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010388e:	a1 bc 35 11 80       	mov    0x801135bc,%eax
80103893:	83 c0 01             	add    $0x1,%eax
80103896:	a3 bc 35 11 80       	mov    %eax,0x801135bc
      release(&log.lock);
8010389b:	83 ec 0c             	sub    $0xc,%esp
8010389e:	68 80 35 11 80       	push   $0x80113580
801038a3:	e8 a9 1a 00 00       	call   80105351 <release>
801038a8:	83 c4 10             	add    $0x10,%esp
      break;
801038ab:	90                   	nop
    }
  }
}
801038ac:	90                   	nop
801038ad:	c9                   	leave  
801038ae:	c3                   	ret    

801038af <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801038af:	55                   	push   %ebp
801038b0:	89 e5                	mov    %esp,%ebp
801038b2:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801038b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801038bc:	83 ec 0c             	sub    $0xc,%esp
801038bf:	68 80 35 11 80       	push   $0x80113580
801038c4:	e8 21 1a 00 00       	call   801052ea <acquire>
801038c9:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801038cc:	a1 bc 35 11 80       	mov    0x801135bc,%eax
801038d1:	83 e8 01             	sub    $0x1,%eax
801038d4:	a3 bc 35 11 80       	mov    %eax,0x801135bc
  if(log.committing)
801038d9:	a1 c0 35 11 80       	mov    0x801135c0,%eax
801038de:	85 c0                	test   %eax,%eax
801038e0:	74 0d                	je     801038ef <end_op+0x40>
    panic("log.committing");
801038e2:	83 ec 0c             	sub    $0xc,%esp
801038e5:	68 10 90 10 80       	push   $0x80109010
801038ea:	e8 77 cc ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801038ef:	a1 bc 35 11 80       	mov    0x801135bc,%eax
801038f4:	85 c0                	test   %eax,%eax
801038f6:	75 13                	jne    8010390b <end_op+0x5c>
    do_commit = 1;
801038f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801038ff:	c7 05 c0 35 11 80 01 	movl   $0x1,0x801135c0
80103906:	00 00 00 
80103909:	eb 10                	jmp    8010391b <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010390b:	83 ec 0c             	sub    $0xc,%esp
8010390e:	68 80 35 11 80       	push   $0x80113580
80103913:	e8 be 17 00 00       	call   801050d6 <wakeup>
80103918:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010391b:	83 ec 0c             	sub    $0xc,%esp
8010391e:	68 80 35 11 80       	push   $0x80113580
80103923:	e8 29 1a 00 00       	call   80105351 <release>
80103928:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010392b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010392f:	74 3f                	je     80103970 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103931:	e8 f5 00 00 00       	call   80103a2b <commit>
    acquire(&log.lock);
80103936:	83 ec 0c             	sub    $0xc,%esp
80103939:	68 80 35 11 80       	push   $0x80113580
8010393e:	e8 a7 19 00 00       	call   801052ea <acquire>
80103943:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103946:	c7 05 c0 35 11 80 00 	movl   $0x0,0x801135c0
8010394d:	00 00 00 
    wakeup(&log);
80103950:	83 ec 0c             	sub    $0xc,%esp
80103953:	68 80 35 11 80       	push   $0x80113580
80103958:	e8 79 17 00 00       	call   801050d6 <wakeup>
8010395d:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	68 80 35 11 80       	push   $0x80113580
80103968:	e8 e4 19 00 00       	call   80105351 <release>
8010396d:	83 c4 10             	add    $0x10,%esp
  }
}
80103970:	90                   	nop
80103971:	c9                   	leave  
80103972:	c3                   	ret    

80103973 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103973:	55                   	push   %ebp
80103974:	89 e5                	mov    %esp,%ebp
80103976:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103979:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103980:	e9 95 00 00 00       	jmp    80103a1a <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103985:	8b 15 b4 35 11 80    	mov    0x801135b4,%edx
8010398b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010398e:	01 d0                	add    %edx,%eax
80103990:	83 c0 01             	add    $0x1,%eax
80103993:	89 c2                	mov    %eax,%edx
80103995:	a1 c4 35 11 80       	mov    0x801135c4,%eax
8010399a:	83 ec 08             	sub    $0x8,%esp
8010399d:	52                   	push   %edx
8010399e:	50                   	push   %eax
8010399f:	e8 12 c8 ff ff       	call   801001b6 <bread>
801039a4:	83 c4 10             	add    $0x10,%esp
801039a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ad:	83 c0 10             	add    $0x10,%eax
801039b0:	8b 04 85 8c 35 11 80 	mov    -0x7feeca74(,%eax,4),%eax
801039b7:	89 c2                	mov    %eax,%edx
801039b9:	a1 c4 35 11 80       	mov    0x801135c4,%eax
801039be:	83 ec 08             	sub    $0x8,%esp
801039c1:	52                   	push   %edx
801039c2:	50                   	push   %eax
801039c3:	e8 ee c7 ff ff       	call   801001b6 <bread>
801039c8:	83 c4 10             	add    $0x10,%esp
801039cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801039ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801039d1:	8d 50 18             	lea    0x18(%eax),%edx
801039d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039d7:	83 c0 18             	add    $0x18,%eax
801039da:	83 ec 04             	sub    $0x4,%esp
801039dd:	68 00 02 00 00       	push   $0x200
801039e2:	52                   	push   %edx
801039e3:	50                   	push   %eax
801039e4:	e8 23 1c 00 00       	call   8010560c <memmove>
801039e9:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801039ec:	83 ec 0c             	sub    $0xc,%esp
801039ef:	ff 75 f0             	pushl  -0x10(%ebp)
801039f2:	e8 f8 c7 ff ff       	call   801001ef <bwrite>
801039f7:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801039fa:	83 ec 0c             	sub    $0xc,%esp
801039fd:	ff 75 ec             	pushl  -0x14(%ebp)
80103a00:	e8 29 c8 ff ff       	call   8010022e <brelse>
80103a05:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103a08:	83 ec 0c             	sub    $0xc,%esp
80103a0b:	ff 75 f0             	pushl  -0x10(%ebp)
80103a0e:	e8 1b c8 ff ff       	call   8010022e <brelse>
80103a13:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a16:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a1a:	a1 c8 35 11 80       	mov    0x801135c8,%eax
80103a1f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a22:	0f 8f 5d ff ff ff    	jg     80103985 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103a28:	90                   	nop
80103a29:	c9                   	leave  
80103a2a:	c3                   	ret    

80103a2b <commit>:

static void
commit()
{
80103a2b:	55                   	push   %ebp
80103a2c:	89 e5                	mov    %esp,%ebp
80103a2e:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103a31:	a1 c8 35 11 80       	mov    0x801135c8,%eax
80103a36:	85 c0                	test   %eax,%eax
80103a38:	7e 1e                	jle    80103a58 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103a3a:	e8 34 ff ff ff       	call   80103973 <write_log>
    write_head();    // Write header to disk -- the real commit
80103a3f:	e8 3a fd ff ff       	call   8010377e <write_head>
    install_trans(); // Now install writes to home locations
80103a44:	e8 09 fc ff ff       	call   80103652 <install_trans>
    log.lh.n = 0; 
80103a49:	c7 05 c8 35 11 80 00 	movl   $0x0,0x801135c8
80103a50:	00 00 00 
    write_head();    // Erase the transaction from the log
80103a53:	e8 26 fd ff ff       	call   8010377e <write_head>
  }
}
80103a58:	90                   	nop
80103a59:	c9                   	leave  
80103a5a:	c3                   	ret    

80103a5b <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103a5b:	55                   	push   %ebp
80103a5c:	89 e5                	mov    %esp,%ebp
80103a5e:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103a61:	a1 c8 35 11 80       	mov    0x801135c8,%eax
80103a66:	83 f8 1d             	cmp    $0x1d,%eax
80103a69:	7f 12                	jg     80103a7d <log_write+0x22>
80103a6b:	a1 c8 35 11 80       	mov    0x801135c8,%eax
80103a70:	8b 15 b8 35 11 80    	mov    0x801135b8,%edx
80103a76:	83 ea 01             	sub    $0x1,%edx
80103a79:	39 d0                	cmp    %edx,%eax
80103a7b:	7c 0d                	jl     80103a8a <log_write+0x2f>
    panic("too big a transaction");
80103a7d:	83 ec 0c             	sub    $0xc,%esp
80103a80:	68 1f 90 10 80       	push   $0x8010901f
80103a85:	e8 dc ca ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103a8a:	a1 bc 35 11 80       	mov    0x801135bc,%eax
80103a8f:	85 c0                	test   %eax,%eax
80103a91:	7f 0d                	jg     80103aa0 <log_write+0x45>
    panic("log_write outside of trans");
80103a93:	83 ec 0c             	sub    $0xc,%esp
80103a96:	68 35 90 10 80       	push   $0x80109035
80103a9b:	e8 c6 ca ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 80 35 11 80       	push   $0x80113580
80103aa8:	e8 3d 18 00 00       	call   801052ea <acquire>
80103aad:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103ab0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ab7:	eb 1d                	jmp    80103ad6 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103abc:	83 c0 10             	add    $0x10,%eax
80103abf:	8b 04 85 8c 35 11 80 	mov    -0x7feeca74(,%eax,4),%eax
80103ac6:	89 c2                	mov    %eax,%edx
80103ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80103acb:	8b 40 08             	mov    0x8(%eax),%eax
80103ace:	39 c2                	cmp    %eax,%edx
80103ad0:	74 10                	je     80103ae2 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103ad2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103ad6:	a1 c8 35 11 80       	mov    0x801135c8,%eax
80103adb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ade:	7f d9                	jg     80103ab9 <log_write+0x5e>
80103ae0:	eb 01                	jmp    80103ae3 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103ae2:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ae6:	8b 40 08             	mov    0x8(%eax),%eax
80103ae9:	89 c2                	mov    %eax,%edx
80103aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aee:	83 c0 10             	add    $0x10,%eax
80103af1:	89 14 85 8c 35 11 80 	mov    %edx,-0x7feeca74(,%eax,4)
  if (i == log.lh.n)
80103af8:	a1 c8 35 11 80       	mov    0x801135c8,%eax
80103afd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b00:	75 0d                	jne    80103b0f <log_write+0xb4>
    log.lh.n++;
80103b02:	a1 c8 35 11 80       	mov    0x801135c8,%eax
80103b07:	83 c0 01             	add    $0x1,%eax
80103b0a:	a3 c8 35 11 80       	mov    %eax,0x801135c8
  b->flags |= B_DIRTY; // prevent eviction
80103b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103b12:	8b 00                	mov    (%eax),%eax
80103b14:	83 c8 04             	or     $0x4,%eax
80103b17:	89 c2                	mov    %eax,%edx
80103b19:	8b 45 08             	mov    0x8(%ebp),%eax
80103b1c:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103b1e:	83 ec 0c             	sub    $0xc,%esp
80103b21:	68 80 35 11 80       	push   $0x80113580
80103b26:	e8 26 18 00 00       	call   80105351 <release>
80103b2b:	83 c4 10             	add    $0x10,%esp
}
80103b2e:	90                   	nop
80103b2f:	c9                   	leave  
80103b30:	c3                   	ret    

80103b31 <v2p>:
80103b31:	55                   	push   %ebp
80103b32:	89 e5                	mov    %esp,%ebp
80103b34:	8b 45 08             	mov    0x8(%ebp),%eax
80103b37:	05 00 00 00 80       	add    $0x80000000,%eax
80103b3c:	5d                   	pop    %ebp
80103b3d:	c3                   	ret    

80103b3e <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103b3e:	55                   	push   %ebp
80103b3f:	89 e5                	mov    %esp,%ebp
80103b41:	8b 45 08             	mov    0x8(%ebp),%eax
80103b44:	05 00 00 00 80       	add    $0x80000000,%eax
80103b49:	5d                   	pop    %ebp
80103b4a:	c3                   	ret    

80103b4b <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103b4b:	55                   	push   %ebp
80103b4c:	89 e5                	mov    %esp,%ebp
80103b4e:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103b51:	8b 55 08             	mov    0x8(%ebp),%edx
80103b54:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103b5a:	f0 87 02             	lock xchg %eax,(%edx)
80103b5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103b60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103b63:	c9                   	leave  
80103b64:	c3                   	ret    

80103b65 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103b65:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103b69:	83 e4 f0             	and    $0xfffffff0,%esp
80103b6c:	ff 71 fc             	pushl  -0x4(%ecx)
80103b6f:	55                   	push   %ebp
80103b70:	89 e5                	mov    %esp,%ebp
80103b72:	51                   	push   %ecx
80103b73:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103b76:	83 ec 08             	sub    $0x8,%esp
80103b79:	68 00 00 40 80       	push   $0x80400000
80103b7e:	68 5c 66 11 80       	push   $0x8011665c
80103b83:	e8 7d f2 ff ff       	call   80102e05 <kinit1>
80103b88:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103b8b:	e8 96 4a 00 00       	call   80108626 <kvmalloc>
  mpinit();        // collect info about this machine
80103b90:	e8 43 04 00 00       	call   80103fd8 <mpinit>
  lapicinit();
80103b95:	e8 ea f5 ff ff       	call   80103184 <lapicinit>
  seginit();       // set up segments
80103b9a:	e8 30 44 00 00       	call   80107fcf <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103b9f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ba5:	0f b6 00             	movzbl (%eax),%eax
80103ba8:	0f b6 c0             	movzbl %al,%eax
80103bab:	83 ec 08             	sub    $0x8,%esp
80103bae:	50                   	push   %eax
80103baf:	68 50 90 10 80       	push   $0x80109050
80103bb4:	e8 0d c8 ff ff       	call   801003c6 <cprintf>
80103bb9:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103bbc:	e8 6d 06 00 00       	call   8010422e <picinit>
  ioapicinit();    // another interrupt controller
80103bc1:	e8 34 f1 ff ff       	call   80102cfa <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103bc6:	e8 1e cf ff ff       	call   80100ae9 <consoleinit>
  uartinit();      // serial port
80103bcb:	e8 5b 37 00 00       	call   8010732b <uartinit>
  pinit();         // process table
80103bd0:	e8 56 0b 00 00       	call   8010472b <pinit>
  tvinit();        // trap vectors
80103bd5:	e8 1b 33 00 00       	call   80106ef5 <tvinit>
  binit();         // buffer cache
80103bda:	e8 55 c4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103bdf:	e8 2c d5 ff ff       	call   80101110 <fileinit>
  ideinit();       // disk
80103be4:	e8 19 ed ff ff       	call   80102902 <ideinit>
  if(!ismp)
80103be9:	a1 64 36 11 80       	mov    0x80113664,%eax
80103bee:	85 c0                	test   %eax,%eax
80103bf0:	75 05                	jne    80103bf7 <main+0x92>
    timerinit();   // uniprocessor timer
80103bf2:	e8 5b 32 00 00       	call   80106e52 <timerinit>
  startothers();   // start other processors
80103bf7:	e8 7f 00 00 00       	call   80103c7b <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103bfc:	83 ec 08             	sub    $0x8,%esp
80103bff:	68 00 00 00 8e       	push   $0x8e000000
80103c04:	68 00 00 40 80       	push   $0x80400000
80103c09:	e8 30 f2 ff ff       	call   80102e3e <kinit2>
80103c0e:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103c11:	e8 3c 0c 00 00       	call   80104852 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103c16:	e8 1a 00 00 00       	call   80103c35 <mpmain>

80103c1b <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103c1b:	55                   	push   %ebp
80103c1c:	89 e5                	mov    %esp,%ebp
80103c1e:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103c21:	e8 18 4a 00 00       	call   8010863e <switchkvm>
  seginit();
80103c26:	e8 a4 43 00 00       	call   80107fcf <seginit>
  lapicinit();
80103c2b:	e8 54 f5 ff ff       	call   80103184 <lapicinit>
  mpmain();
80103c30:	e8 00 00 00 00       	call   80103c35 <mpmain>

80103c35 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103c35:	55                   	push   %ebp
80103c36:	89 e5                	mov    %esp,%ebp
80103c38:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103c3b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c41:	0f b6 00             	movzbl (%eax),%eax
80103c44:	0f b6 c0             	movzbl %al,%eax
80103c47:	83 ec 08             	sub    $0x8,%esp
80103c4a:	50                   	push   %eax
80103c4b:	68 67 90 10 80       	push   $0x80109067
80103c50:	e8 71 c7 ff ff       	call   801003c6 <cprintf>
80103c55:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103c58:	e8 0e 34 00 00       	call   8010706b <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103c5d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c63:	05 a8 00 00 00       	add    $0xa8,%eax
80103c68:	83 ec 08             	sub    $0x8,%esp
80103c6b:	6a 01                	push   $0x1
80103c6d:	50                   	push   %eax
80103c6e:	e8 d8 fe ff ff       	call   80103b4b <xchg>
80103c73:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103c76:	e8 88 11 00 00       	call   80104e03 <scheduler>

80103c7b <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103c7b:	55                   	push   %ebp
80103c7c:	89 e5                	mov    %esp,%ebp
80103c7e:	53                   	push   %ebx
80103c7f:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103c82:	68 00 70 00 00       	push   $0x7000
80103c87:	e8 b2 fe ff ff       	call   80103b3e <p2v>
80103c8c:	83 c4 04             	add    $0x4,%esp
80103c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103c92:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103c97:	83 ec 04             	sub    $0x4,%esp
80103c9a:	50                   	push   %eax
80103c9b:	68 4c c5 10 80       	push   $0x8010c54c
80103ca0:	ff 75 f0             	pushl  -0x10(%ebp)
80103ca3:	e8 64 19 00 00       	call   8010560c <memmove>
80103ca8:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103cab:	c7 45 f4 80 36 11 80 	movl   $0x80113680,-0xc(%ebp)
80103cb2:	e9 90 00 00 00       	jmp    80103d47 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103cb7:	e8 e6 f5 ff ff       	call   801032a2 <cpunum>
80103cbc:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103cc2:	05 80 36 11 80       	add    $0x80113680,%eax
80103cc7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103cca:	74 73                	je     80103d3f <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103ccc:	e8 6b f2 ff ff       	call   80102f3c <kalloc>
80103cd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd7:	83 e8 04             	sub    $0x4,%eax
80103cda:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103cdd:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103ce3:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce8:	83 e8 08             	sub    $0x8,%eax
80103ceb:	c7 00 1b 3c 10 80    	movl   $0x80103c1b,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf4:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103cf7:	83 ec 0c             	sub    $0xc,%esp
80103cfa:	68 00 b0 10 80       	push   $0x8010b000
80103cff:	e8 2d fe ff ff       	call   80103b31 <v2p>
80103d04:	83 c4 10             	add    $0x10,%esp
80103d07:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103d09:	83 ec 0c             	sub    $0xc,%esp
80103d0c:	ff 75 f0             	pushl  -0x10(%ebp)
80103d0f:	e8 1d fe ff ff       	call   80103b31 <v2p>
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	89 c2                	mov    %eax,%edx
80103d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1c:	0f b6 00             	movzbl (%eax),%eax
80103d1f:	0f b6 c0             	movzbl %al,%eax
80103d22:	83 ec 08             	sub    $0x8,%esp
80103d25:	52                   	push   %edx
80103d26:	50                   	push   %eax
80103d27:	e8 f0 f5 ff ff       	call   8010331c <lapicstartap>
80103d2c:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103d2f:	90                   	nop
80103d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d33:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103d39:	85 c0                	test   %eax,%eax
80103d3b:	74 f3                	je     80103d30 <startothers+0xb5>
80103d3d:	eb 01                	jmp    80103d40 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103d3f:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103d40:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103d47:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80103d4c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d52:	05 80 36 11 80       	add    $0x80113680,%eax
80103d57:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d5a:	0f 87 57 ff ff ff    	ja     80103cb7 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103d60:	90                   	nop
80103d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d64:	c9                   	leave  
80103d65:	c3                   	ret    

80103d66 <p2v>:
80103d66:	55                   	push   %ebp
80103d67:	89 e5                	mov    %esp,%ebp
80103d69:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6c:	05 00 00 00 80       	add    $0x80000000,%eax
80103d71:	5d                   	pop    %ebp
80103d72:	c3                   	ret    

80103d73 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103d73:	55                   	push   %ebp
80103d74:	89 e5                	mov    %esp,%ebp
80103d76:	83 ec 14             	sub    $0x14,%esp
80103d79:	8b 45 08             	mov    0x8(%ebp),%eax
80103d7c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d80:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103d84:	89 c2                	mov    %eax,%edx
80103d86:	ec                   	in     (%dx),%al
80103d87:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103d8a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103d8e:	c9                   	leave  
80103d8f:	c3                   	ret    

80103d90 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	83 ec 08             	sub    $0x8,%esp
80103d96:	8b 55 08             	mov    0x8(%ebp),%edx
80103d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d9c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103da0:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103da3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103da7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103dab:	ee                   	out    %al,(%dx)
}
80103dac:	90                   	nop
80103dad:	c9                   	leave  
80103dae:	c3                   	ret    

80103daf <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103daf:	55                   	push   %ebp
80103db0:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103db2:	a1 84 c6 10 80       	mov    0x8010c684,%eax
80103db7:	89 c2                	mov    %eax,%edx
80103db9:	b8 80 36 11 80       	mov    $0x80113680,%eax
80103dbe:	29 c2                	sub    %eax,%edx
80103dc0:	89 d0                	mov    %edx,%eax
80103dc2:	c1 f8 02             	sar    $0x2,%eax
80103dc5:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103dcb:	5d                   	pop    %ebp
80103dcc:	c3                   	ret    

80103dcd <sum>:

static uchar
sum(uchar *addr, int len)
{
80103dcd:	55                   	push   %ebp
80103dce:	89 e5                	mov    %esp,%ebp
80103dd0:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103dd3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103dda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103de1:	eb 15                	jmp    80103df8 <sum+0x2b>
    sum += addr[i];
80103de3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103de6:	8b 45 08             	mov    0x8(%ebp),%eax
80103de9:	01 d0                	add    %edx,%eax
80103deb:	0f b6 00             	movzbl (%eax),%eax
80103dee:	0f b6 c0             	movzbl %al,%eax
80103df1:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103df4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103dfb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103dfe:	7c e3                	jl     80103de3 <sum+0x16>
    sum += addr[i];
  return sum;
80103e00:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103e03:	c9                   	leave  
80103e04:	c3                   	ret    

80103e05 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103e05:	55                   	push   %ebp
80103e06:	89 e5                	mov    %esp,%ebp
80103e08:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103e0b:	ff 75 08             	pushl  0x8(%ebp)
80103e0e:	e8 53 ff ff ff       	call   80103d66 <p2v>
80103e13:	83 c4 04             	add    $0x4,%esp
80103e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103e19:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e1f:	01 d0                	add    %edx,%eax
80103e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e2a:	eb 36                	jmp    80103e62 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e2c:	83 ec 04             	sub    $0x4,%esp
80103e2f:	6a 04                	push   $0x4
80103e31:	68 78 90 10 80       	push   $0x80109078
80103e36:	ff 75 f4             	pushl  -0xc(%ebp)
80103e39:	e8 76 17 00 00       	call   801055b4 <memcmp>
80103e3e:	83 c4 10             	add    $0x10,%esp
80103e41:	85 c0                	test   %eax,%eax
80103e43:	75 19                	jne    80103e5e <mpsearch1+0x59>
80103e45:	83 ec 08             	sub    $0x8,%esp
80103e48:	6a 10                	push   $0x10
80103e4a:	ff 75 f4             	pushl  -0xc(%ebp)
80103e4d:	e8 7b ff ff ff       	call   80103dcd <sum>
80103e52:	83 c4 10             	add    $0x10,%esp
80103e55:	84 c0                	test   %al,%al
80103e57:	75 05                	jne    80103e5e <mpsearch1+0x59>
      return (struct mp*)p;
80103e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e5c:	eb 11                	jmp    80103e6f <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103e5e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103e68:	72 c2                	jb     80103e2c <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103e6f:	c9                   	leave  
80103e70:	c3                   	ret    

80103e71 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103e71:	55                   	push   %ebp
80103e72:	89 e5                	mov    %esp,%ebp
80103e74:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103e77:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e81:	83 c0 0f             	add    $0xf,%eax
80103e84:	0f b6 00             	movzbl (%eax),%eax
80103e87:	0f b6 c0             	movzbl %al,%eax
80103e8a:	c1 e0 08             	shl    $0x8,%eax
80103e8d:	89 c2                	mov    %eax,%edx
80103e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e92:	83 c0 0e             	add    $0xe,%eax
80103e95:	0f b6 00             	movzbl (%eax),%eax
80103e98:	0f b6 c0             	movzbl %al,%eax
80103e9b:	09 d0                	or     %edx,%eax
80103e9d:	c1 e0 04             	shl    $0x4,%eax
80103ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ea3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ea7:	74 21                	je     80103eca <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103ea9:	83 ec 08             	sub    $0x8,%esp
80103eac:	68 00 04 00 00       	push   $0x400
80103eb1:	ff 75 f0             	pushl  -0x10(%ebp)
80103eb4:	e8 4c ff ff ff       	call   80103e05 <mpsearch1>
80103eb9:	83 c4 10             	add    $0x10,%esp
80103ebc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ebf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ec3:	74 51                	je     80103f16 <mpsearch+0xa5>
      return mp;
80103ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ec8:	eb 61                	jmp    80103f2b <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ecd:	83 c0 14             	add    $0x14,%eax
80103ed0:	0f b6 00             	movzbl (%eax),%eax
80103ed3:	0f b6 c0             	movzbl %al,%eax
80103ed6:	c1 e0 08             	shl    $0x8,%eax
80103ed9:	89 c2                	mov    %eax,%edx
80103edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ede:	83 c0 13             	add    $0x13,%eax
80103ee1:	0f b6 00             	movzbl (%eax),%eax
80103ee4:	0f b6 c0             	movzbl %al,%eax
80103ee7:	09 d0                	or     %edx,%eax
80103ee9:	c1 e0 0a             	shl    $0xa,%eax
80103eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ef2:	2d 00 04 00 00       	sub    $0x400,%eax
80103ef7:	83 ec 08             	sub    $0x8,%esp
80103efa:	68 00 04 00 00       	push   $0x400
80103eff:	50                   	push   %eax
80103f00:	e8 00 ff ff ff       	call   80103e05 <mpsearch1>
80103f05:	83 c4 10             	add    $0x10,%esp
80103f08:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f0f:	74 05                	je     80103f16 <mpsearch+0xa5>
      return mp;
80103f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f14:	eb 15                	jmp    80103f2b <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103f16:	83 ec 08             	sub    $0x8,%esp
80103f19:	68 00 00 01 00       	push   $0x10000
80103f1e:	68 00 00 0f 00       	push   $0xf0000
80103f23:	e8 dd fe ff ff       	call   80103e05 <mpsearch1>
80103f28:	83 c4 10             	add    $0x10,%esp
}
80103f2b:	c9                   	leave  
80103f2c:	c3                   	ret    

80103f2d <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103f2d:	55                   	push   %ebp
80103f2e:	89 e5                	mov    %esp,%ebp
80103f30:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103f33:	e8 39 ff ff ff       	call   80103e71 <mpsearch>
80103f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f3f:	74 0a                	je     80103f4b <mpconfig+0x1e>
80103f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f44:	8b 40 04             	mov    0x4(%eax),%eax
80103f47:	85 c0                	test   %eax,%eax
80103f49:	75 0a                	jne    80103f55 <mpconfig+0x28>
    return 0;
80103f4b:	b8 00 00 00 00       	mov    $0x0,%eax
80103f50:	e9 81 00 00 00       	jmp    80103fd6 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f58:	8b 40 04             	mov    0x4(%eax),%eax
80103f5b:	83 ec 0c             	sub    $0xc,%esp
80103f5e:	50                   	push   %eax
80103f5f:	e8 02 fe ff ff       	call   80103d66 <p2v>
80103f64:	83 c4 10             	add    $0x10,%esp
80103f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103f6a:	83 ec 04             	sub    $0x4,%esp
80103f6d:	6a 04                	push   $0x4
80103f6f:	68 7d 90 10 80       	push   $0x8010907d
80103f74:	ff 75 f0             	pushl  -0x10(%ebp)
80103f77:	e8 38 16 00 00       	call   801055b4 <memcmp>
80103f7c:	83 c4 10             	add    $0x10,%esp
80103f7f:	85 c0                	test   %eax,%eax
80103f81:	74 07                	je     80103f8a <mpconfig+0x5d>
    return 0;
80103f83:	b8 00 00 00 00       	mov    $0x0,%eax
80103f88:	eb 4c                	jmp    80103fd6 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f8d:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103f91:	3c 01                	cmp    $0x1,%al
80103f93:	74 12                	je     80103fa7 <mpconfig+0x7a>
80103f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f98:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103f9c:	3c 04                	cmp    $0x4,%al
80103f9e:	74 07                	je     80103fa7 <mpconfig+0x7a>
    return 0;
80103fa0:	b8 00 00 00 00       	mov    $0x0,%eax
80103fa5:	eb 2f                	jmp    80103fd6 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103faa:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103fae:	0f b7 c0             	movzwl %ax,%eax
80103fb1:	83 ec 08             	sub    $0x8,%esp
80103fb4:	50                   	push   %eax
80103fb5:	ff 75 f0             	pushl  -0x10(%ebp)
80103fb8:	e8 10 fe ff ff       	call   80103dcd <sum>
80103fbd:	83 c4 10             	add    $0x10,%esp
80103fc0:	84 c0                	test   %al,%al
80103fc2:	74 07                	je     80103fcb <mpconfig+0x9e>
    return 0;
80103fc4:	b8 00 00 00 00       	mov    $0x0,%eax
80103fc9:	eb 0b                	jmp    80103fd6 <mpconfig+0xa9>
  *pmp = mp;
80103fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fce:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fd1:	89 10                	mov    %edx,(%eax)
  return conf;
80103fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103fd6:	c9                   	leave  
80103fd7:	c3                   	ret    

80103fd8 <mpinit>:

void
mpinit(void)
{
80103fd8:	55                   	push   %ebp
80103fd9:	89 e5                	mov    %esp,%ebp
80103fdb:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103fde:	c7 05 84 c6 10 80 80 	movl   $0x80113680,0x8010c684
80103fe5:	36 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103fe8:	83 ec 0c             	sub    $0xc,%esp
80103feb:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103fee:	50                   	push   %eax
80103fef:	e8 39 ff ff ff       	call   80103f2d <mpconfig>
80103ff4:	83 c4 10             	add    $0x10,%esp
80103ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ffa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ffe:	0f 84 96 01 00 00    	je     8010419a <mpinit+0x1c2>
    return;
  ismp = 1;
80104004:	c7 05 64 36 11 80 01 	movl   $0x1,0x80113664
8010400b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010400e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104011:	8b 40 24             	mov    0x24(%eax),%eax
80104014:	a3 7c 35 11 80       	mov    %eax,0x8011357c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104019:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010401c:	83 c0 2c             	add    $0x2c,%eax
8010401f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104022:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104025:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104029:	0f b7 d0             	movzwl %ax,%edx
8010402c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010402f:	01 d0                	add    %edx,%eax
80104031:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104034:	e9 f2 00 00 00       	jmp    8010412b <mpinit+0x153>
    switch(*p){
80104039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403c:	0f b6 00             	movzbl (%eax),%eax
8010403f:	0f b6 c0             	movzbl %al,%eax
80104042:	83 f8 04             	cmp    $0x4,%eax
80104045:	0f 87 bc 00 00 00    	ja     80104107 <mpinit+0x12f>
8010404b:	8b 04 85 c0 90 10 80 	mov    -0x7fef6f40(,%eax,4),%eax
80104052:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80104054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104057:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
8010405a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010405d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104061:	0f b6 d0             	movzbl %al,%edx
80104064:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80104069:	39 c2                	cmp    %eax,%edx
8010406b:	74 2b                	je     80104098 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
8010406d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104070:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104074:	0f b6 d0             	movzbl %al,%edx
80104077:	a1 60 3c 11 80       	mov    0x80113c60,%eax
8010407c:	83 ec 04             	sub    $0x4,%esp
8010407f:	52                   	push   %edx
80104080:	50                   	push   %eax
80104081:	68 82 90 10 80       	push   $0x80109082
80104086:	e8 3b c3 ff ff       	call   801003c6 <cprintf>
8010408b:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
8010408e:	c7 05 64 36 11 80 00 	movl   $0x0,0x80113664
80104095:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80104098:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010409b:	0f b6 40 03          	movzbl 0x3(%eax),%eax
8010409f:	0f b6 c0             	movzbl %al,%eax
801040a2:	83 e0 02             	and    $0x2,%eax
801040a5:	85 c0                	test   %eax,%eax
801040a7:	74 15                	je     801040be <mpinit+0xe6>
        bcpu = &cpus[ncpu];
801040a9:	a1 60 3c 11 80       	mov    0x80113c60,%eax
801040ae:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801040b4:	05 80 36 11 80       	add    $0x80113680,%eax
801040b9:	a3 84 c6 10 80       	mov    %eax,0x8010c684
      cpus[ncpu].id = ncpu;
801040be:	a1 60 3c 11 80       	mov    0x80113c60,%eax
801040c3:	8b 15 60 3c 11 80    	mov    0x80113c60,%edx
801040c9:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801040cf:	05 80 36 11 80       	add    $0x80113680,%eax
801040d4:	88 10                	mov    %dl,(%eax)
      ncpu++;
801040d6:	a1 60 3c 11 80       	mov    0x80113c60,%eax
801040db:	83 c0 01             	add    $0x1,%eax
801040de:	a3 60 3c 11 80       	mov    %eax,0x80113c60
      p += sizeof(struct mpproc);
801040e3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
801040e7:	eb 42                	jmp    8010412b <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
801040e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801040ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801040f2:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040f6:	a2 60 36 11 80       	mov    %al,0x80113660
      p += sizeof(struct mpioapic);
801040fb:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801040ff:	eb 2a                	jmp    8010412b <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104101:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104105:	eb 24                	jmp    8010412b <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80104107:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010410a:	0f b6 00             	movzbl (%eax),%eax
8010410d:	0f b6 c0             	movzbl %al,%eax
80104110:	83 ec 08             	sub    $0x8,%esp
80104113:	50                   	push   %eax
80104114:	68 a0 90 10 80       	push   $0x801090a0
80104119:	e8 a8 c2 ff ff       	call   801003c6 <cprintf>
8010411e:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80104121:	c7 05 64 36 11 80 00 	movl   $0x0,0x80113664
80104128:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010412b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104131:	0f 82 02 ff ff ff    	jb     80104039 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80104137:	a1 64 36 11 80       	mov    0x80113664,%eax
8010413c:	85 c0                	test   %eax,%eax
8010413e:	75 1d                	jne    8010415d <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80104140:	c7 05 60 3c 11 80 01 	movl   $0x1,0x80113c60
80104147:	00 00 00 
    lapic = 0;
8010414a:	c7 05 7c 35 11 80 00 	movl   $0x0,0x8011357c
80104151:	00 00 00 
    ioapicid = 0;
80104154:	c6 05 60 36 11 80 00 	movb   $0x0,0x80113660
    return;
8010415b:	eb 3e                	jmp    8010419b <mpinit+0x1c3>
  }

  if(mp->imcrp){
8010415d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104160:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104164:	84 c0                	test   %al,%al
80104166:	74 33                	je     8010419b <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80104168:	83 ec 08             	sub    $0x8,%esp
8010416b:	6a 70                	push   $0x70
8010416d:	6a 22                	push   $0x22
8010416f:	e8 1c fc ff ff       	call   80103d90 <outb>
80104174:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104177:	83 ec 0c             	sub    $0xc,%esp
8010417a:	6a 23                	push   $0x23
8010417c:	e8 f2 fb ff ff       	call   80103d73 <inb>
80104181:	83 c4 10             	add    $0x10,%esp
80104184:	83 c8 01             	or     $0x1,%eax
80104187:	0f b6 c0             	movzbl %al,%eax
8010418a:	83 ec 08             	sub    $0x8,%esp
8010418d:	50                   	push   %eax
8010418e:	6a 23                	push   $0x23
80104190:	e8 fb fb ff ff       	call   80103d90 <outb>
80104195:	83 c4 10             	add    $0x10,%esp
80104198:	eb 01                	jmp    8010419b <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
8010419a:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010419b:	c9                   	leave  
8010419c:	c3                   	ret    

8010419d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010419d:	55                   	push   %ebp
8010419e:	89 e5                	mov    %esp,%ebp
801041a0:	83 ec 08             	sub    $0x8,%esp
801041a3:	8b 55 08             	mov    0x8(%ebp),%edx
801041a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801041a9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801041ad:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801041b0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801041b4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801041b8:	ee                   	out    %al,(%dx)
}
801041b9:	90                   	nop
801041ba:	c9                   	leave  
801041bb:	c3                   	ret    

801041bc <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
801041bc:	55                   	push   %ebp
801041bd:	89 e5                	mov    %esp,%ebp
801041bf:	83 ec 04             	sub    $0x4,%esp
801041c2:	8b 45 08             	mov    0x8(%ebp),%eax
801041c5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
801041c9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801041cd:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
801041d3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801041d7:	0f b6 c0             	movzbl %al,%eax
801041da:	50                   	push   %eax
801041db:	6a 21                	push   $0x21
801041dd:	e8 bb ff ff ff       	call   8010419d <outb>
801041e2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
801041e5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801041e9:	66 c1 e8 08          	shr    $0x8,%ax
801041ed:	0f b6 c0             	movzbl %al,%eax
801041f0:	50                   	push   %eax
801041f1:	68 a1 00 00 00       	push   $0xa1
801041f6:	e8 a2 ff ff ff       	call   8010419d <outb>
801041fb:	83 c4 08             	add    $0x8,%esp
}
801041fe:	90                   	nop
801041ff:	c9                   	leave  
80104200:	c3                   	ret    

80104201 <picenable>:

void
picenable(int irq)
{
80104201:	55                   	push   %ebp
80104202:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80104204:	8b 45 08             	mov    0x8(%ebp),%eax
80104207:	ba 01 00 00 00       	mov    $0x1,%edx
8010420c:	89 c1                	mov    %eax,%ecx
8010420e:	d3 e2                	shl    %cl,%edx
80104210:	89 d0                	mov    %edx,%eax
80104212:	f7 d0                	not    %eax
80104214:	89 c2                	mov    %eax,%edx
80104216:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
8010421d:	21 d0                	and    %edx,%eax
8010421f:	0f b7 c0             	movzwl %ax,%eax
80104222:	50                   	push   %eax
80104223:	e8 94 ff ff ff       	call   801041bc <picsetmask>
80104228:	83 c4 04             	add    $0x4,%esp
}
8010422b:	90                   	nop
8010422c:	c9                   	leave  
8010422d:	c3                   	ret    

8010422e <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
8010422e:	55                   	push   %ebp
8010422f:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104231:	68 ff 00 00 00       	push   $0xff
80104236:	6a 21                	push   $0x21
80104238:	e8 60 ff ff ff       	call   8010419d <outb>
8010423d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104240:	68 ff 00 00 00       	push   $0xff
80104245:	68 a1 00 00 00       	push   $0xa1
8010424a:	e8 4e ff ff ff       	call   8010419d <outb>
8010424f:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104252:	6a 11                	push   $0x11
80104254:	6a 20                	push   $0x20
80104256:	e8 42 ff ff ff       	call   8010419d <outb>
8010425b:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
8010425e:	6a 20                	push   $0x20
80104260:	6a 21                	push   $0x21
80104262:	e8 36 ff ff ff       	call   8010419d <outb>
80104267:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010426a:	6a 04                	push   $0x4
8010426c:	6a 21                	push   $0x21
8010426e:	e8 2a ff ff ff       	call   8010419d <outb>
80104273:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80104276:	6a 03                	push   $0x3
80104278:	6a 21                	push   $0x21
8010427a:	e8 1e ff ff ff       	call   8010419d <outb>
8010427f:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104282:	6a 11                	push   $0x11
80104284:	68 a0 00 00 00       	push   $0xa0
80104289:	e8 0f ff ff ff       	call   8010419d <outb>
8010428e:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104291:	6a 28                	push   $0x28
80104293:	68 a1 00 00 00       	push   $0xa1
80104298:	e8 00 ff ff ff       	call   8010419d <outb>
8010429d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801042a0:	6a 02                	push   $0x2
801042a2:	68 a1 00 00 00       	push   $0xa1
801042a7:	e8 f1 fe ff ff       	call   8010419d <outb>
801042ac:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
801042af:	6a 03                	push   $0x3
801042b1:	68 a1 00 00 00       	push   $0xa1
801042b6:	e8 e2 fe ff ff       	call   8010419d <outb>
801042bb:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
801042be:	6a 68                	push   $0x68
801042c0:	6a 20                	push   $0x20
801042c2:	e8 d6 fe ff ff       	call   8010419d <outb>
801042c7:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
801042ca:	6a 0a                	push   $0xa
801042cc:	6a 20                	push   $0x20
801042ce:	e8 ca fe ff ff       	call   8010419d <outb>
801042d3:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
801042d6:	6a 68                	push   $0x68
801042d8:	68 a0 00 00 00       	push   $0xa0
801042dd:	e8 bb fe ff ff       	call   8010419d <outb>
801042e2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801042e5:	6a 0a                	push   $0xa
801042e7:	68 a0 00 00 00       	push   $0xa0
801042ec:	e8 ac fe ff ff       	call   8010419d <outb>
801042f1:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801042f4:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801042fb:	66 83 f8 ff          	cmp    $0xffff,%ax
801042ff:	74 13                	je     80104314 <picinit+0xe6>
    picsetmask(irqmask);
80104301:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104308:	0f b7 c0             	movzwl %ax,%eax
8010430b:	50                   	push   %eax
8010430c:	e8 ab fe ff ff       	call   801041bc <picsetmask>
80104311:	83 c4 04             	add    $0x4,%esp
}
80104314:	90                   	nop
80104315:	c9                   	leave  
80104316:	c3                   	ret    

80104317 <pipealloc>:
};*/


int
pipealloc(struct file **f0, struct file **f1)
{
80104317:	55                   	push   %ebp
80104318:	89 e5                	mov    %esp,%ebp
8010431a:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010431d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104324:	8b 45 0c             	mov    0xc(%ebp),%eax
80104327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010432d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104330:	8b 10                	mov    (%eax),%edx
80104332:	8b 45 08             	mov    0x8(%ebp),%eax
80104335:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104337:	e8 f2 cd ff ff       	call   8010112e <filealloc>
8010433c:	89 c2                	mov    %eax,%edx
8010433e:	8b 45 08             	mov    0x8(%ebp),%eax
80104341:	89 10                	mov    %edx,(%eax)
80104343:	8b 45 08             	mov    0x8(%ebp),%eax
80104346:	8b 00                	mov    (%eax),%eax
80104348:	85 c0                	test   %eax,%eax
8010434a:	0f 84 cb 00 00 00    	je     8010441b <pipealloc+0x104>
80104350:	e8 d9 cd ff ff       	call   8010112e <filealloc>
80104355:	89 c2                	mov    %eax,%edx
80104357:	8b 45 0c             	mov    0xc(%ebp),%eax
8010435a:	89 10                	mov    %edx,(%eax)
8010435c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010435f:	8b 00                	mov    (%eax),%eax
80104361:	85 c0                	test   %eax,%eax
80104363:	0f 84 b2 00 00 00    	je     8010441b <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104369:	e8 ce eb ff ff       	call   80102f3c <kalloc>
8010436e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104375:	0f 84 9f 00 00 00    	je     8010441a <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
8010437b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437e:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104385:	00 00 00 
  p->writeopen = 1;
80104388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438b:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104392:	00 00 00 
  p->nwrite = 0;
80104395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104398:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010439f:	00 00 00 
  p->nread = 0;
801043a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a5:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801043ac:	00 00 00 
  initlock(&p->lock, "pipe");
801043af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b2:	83 ec 08             	sub    $0x8,%esp
801043b5:	68 d4 90 10 80       	push   $0x801090d4
801043ba:	50                   	push   %eax
801043bb:	e8 08 0f 00 00       	call   801052c8 <initlock>
801043c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801043c3:	8b 45 08             	mov    0x8(%ebp),%eax
801043c6:	8b 00                	mov    (%eax),%eax
801043c8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801043ce:	8b 45 08             	mov    0x8(%ebp),%eax
801043d1:	8b 00                	mov    (%eax),%eax
801043d3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801043d7:	8b 45 08             	mov    0x8(%ebp),%eax
801043da:	8b 00                	mov    (%eax),%eax
801043dc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801043e0:	8b 45 08             	mov    0x8(%ebp),%eax
801043e3:	8b 00                	mov    (%eax),%eax
801043e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043e8:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801043eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ee:	8b 00                	mov    (%eax),%eax
801043f0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801043f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801043f9:	8b 00                	mov    (%eax),%eax
801043fb:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801043ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104402:	8b 00                	mov    (%eax),%eax
80104404:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104408:	8b 45 0c             	mov    0xc(%ebp),%eax
8010440b:	8b 00                	mov    (%eax),%eax
8010440d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104410:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104413:	b8 00 00 00 00       	mov    $0x0,%eax
80104418:	eb 4e                	jmp    80104468 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
8010441a:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
8010441b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010441f:	74 0e                	je     8010442f <pipealloc+0x118>
    kfree((char*)p);
80104421:	83 ec 0c             	sub    $0xc,%esp
80104424:	ff 75 f4             	pushl  -0xc(%ebp)
80104427:	e8 73 ea ff ff       	call   80102e9f <kfree>
8010442c:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010442f:	8b 45 08             	mov    0x8(%ebp),%eax
80104432:	8b 00                	mov    (%eax),%eax
80104434:	85 c0                	test   %eax,%eax
80104436:	74 11                	je     80104449 <pipealloc+0x132>
    fileclose(*f0);
80104438:	8b 45 08             	mov    0x8(%ebp),%eax
8010443b:	8b 00                	mov    (%eax),%eax
8010443d:	83 ec 0c             	sub    $0xc,%esp
80104440:	50                   	push   %eax
80104441:	e8 a6 cd ff ff       	call   801011ec <fileclose>
80104446:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104449:	8b 45 0c             	mov    0xc(%ebp),%eax
8010444c:	8b 00                	mov    (%eax),%eax
8010444e:	85 c0                	test   %eax,%eax
80104450:	74 11                	je     80104463 <pipealloc+0x14c>
    fileclose(*f1);
80104452:	8b 45 0c             	mov    0xc(%ebp),%eax
80104455:	8b 00                	mov    (%eax),%eax
80104457:	83 ec 0c             	sub    $0xc,%esp
8010445a:	50                   	push   %eax
8010445b:	e8 8c cd ff ff       	call   801011ec <fileclose>
80104460:	83 c4 10             	add    $0x10,%esp
  return -1;
80104463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104468:	c9                   	leave  
80104469:	c3                   	ret    

8010446a <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010446a:	55                   	push   %ebp
8010446b:	89 e5                	mov    %esp,%ebp
8010446d:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104470:	8b 45 08             	mov    0x8(%ebp),%eax
80104473:	83 ec 0c             	sub    $0xc,%esp
80104476:	50                   	push   %eax
80104477:	e8 6e 0e 00 00       	call   801052ea <acquire>
8010447c:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010447f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104483:	74 23                	je     801044a8 <pipeclose+0x3e>
    p->writeopen = 0;
80104485:	8b 45 08             	mov    0x8(%ebp),%eax
80104488:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010448f:	00 00 00 
    wakeup(&p->nread);
80104492:	8b 45 08             	mov    0x8(%ebp),%eax
80104495:	05 34 02 00 00       	add    $0x234,%eax
8010449a:	83 ec 0c             	sub    $0xc,%esp
8010449d:	50                   	push   %eax
8010449e:	e8 33 0c 00 00       	call   801050d6 <wakeup>
801044a3:	83 c4 10             	add    $0x10,%esp
801044a6:	eb 21                	jmp    801044c9 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801044a8:	8b 45 08             	mov    0x8(%ebp),%eax
801044ab:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801044b2:	00 00 00 
    wakeup(&p->nwrite);
801044b5:	8b 45 08             	mov    0x8(%ebp),%eax
801044b8:	05 38 02 00 00       	add    $0x238,%eax
801044bd:	83 ec 0c             	sub    $0xc,%esp
801044c0:	50                   	push   %eax
801044c1:	e8 10 0c 00 00       	call   801050d6 <wakeup>
801044c6:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801044c9:	8b 45 08             	mov    0x8(%ebp),%eax
801044cc:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801044d2:	85 c0                	test   %eax,%eax
801044d4:	75 2c                	jne    80104502 <pipeclose+0x98>
801044d6:	8b 45 08             	mov    0x8(%ebp),%eax
801044d9:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801044df:	85 c0                	test   %eax,%eax
801044e1:	75 1f                	jne    80104502 <pipeclose+0x98>
    release(&p->lock);
801044e3:	8b 45 08             	mov    0x8(%ebp),%eax
801044e6:	83 ec 0c             	sub    $0xc,%esp
801044e9:	50                   	push   %eax
801044ea:	e8 62 0e 00 00       	call   80105351 <release>
801044ef:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801044f2:	83 ec 0c             	sub    $0xc,%esp
801044f5:	ff 75 08             	pushl  0x8(%ebp)
801044f8:	e8 a2 e9 ff ff       	call   80102e9f <kfree>
801044fd:	83 c4 10             	add    $0x10,%esp
80104500:	eb 0f                	jmp    80104511 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104502:	8b 45 08             	mov    0x8(%ebp),%eax
80104505:	83 ec 0c             	sub    $0xc,%esp
80104508:	50                   	push   %eax
80104509:	e8 43 0e 00 00       	call   80105351 <release>
8010450e:	83 c4 10             	add    $0x10,%esp
}
80104511:	90                   	nop
80104512:	c9                   	leave  
80104513:	c3                   	ret    

80104514 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010451a:	8b 45 08             	mov    0x8(%ebp),%eax
8010451d:	83 ec 0c             	sub    $0xc,%esp
80104520:	50                   	push   %eax
80104521:	e8 c4 0d 00 00       	call   801052ea <acquire>
80104526:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104529:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104530:	e9 ad 00 00 00       	jmp    801045e2 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed) {
80104535:	8b 45 08             	mov    0x8(%ebp),%eax
80104538:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010453e:	85 c0                	test   %eax,%eax
80104540:	74 0d                	je     8010454f <pipewrite+0x3b>
80104542:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104548:	8b 40 24             	mov    0x24(%eax),%eax
8010454b:	85 c0                	test   %eax,%eax
8010454d:	74 19                	je     80104568 <pipewrite+0x54>
        release(&p->lock);
8010454f:	8b 45 08             	mov    0x8(%ebp),%eax
80104552:	83 ec 0c             	sub    $0xc,%esp
80104555:	50                   	push   %eax
80104556:	e8 f6 0d 00 00       	call   80105351 <release>
8010455b:	83 c4 10             	add    $0x10,%esp
        return -1;
8010455e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104563:	e9 a8 00 00 00       	jmp    80104610 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104568:	8b 45 08             	mov    0x8(%ebp),%eax
8010456b:	05 34 02 00 00       	add    $0x234,%eax
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	50                   	push   %eax
80104574:	e8 5d 0b 00 00       	call   801050d6 <wakeup>
80104579:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010457c:	8b 45 08             	mov    0x8(%ebp),%eax
8010457f:	8b 55 08             	mov    0x8(%ebp),%edx
80104582:	81 c2 38 02 00 00    	add    $0x238,%edx
80104588:	83 ec 08             	sub    $0x8,%esp
8010458b:	50                   	push   %eax
8010458c:	52                   	push   %edx
8010458d:	e8 56 0a 00 00       	call   80104fe8 <sleep>
80104592:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104595:	8b 45 08             	mov    0x8(%ebp),%eax
80104598:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010459e:	8b 45 08             	mov    0x8(%ebp),%eax
801045a1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801045a7:	05 00 02 00 00       	add    $0x200,%eax
801045ac:	39 c2                	cmp    %eax,%edx
801045ae:	74 85                	je     80104535 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801045b0:	8b 45 08             	mov    0x8(%ebp),%eax
801045b3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801045b9:	8d 48 01             	lea    0x1(%eax),%ecx
801045bc:	8b 55 08             	mov    0x8(%ebp),%edx
801045bf:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801045c5:	25 ff 01 00 00       	and    $0x1ff,%eax
801045ca:	89 c1                	mov    %eax,%ecx
801045cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801045d2:	01 d0                	add    %edx,%eax
801045d4:	0f b6 10             	movzbl (%eax),%edx
801045d7:	8b 45 08             	mov    0x8(%ebp),%eax
801045da:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801045de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801045e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e5:	3b 45 10             	cmp    0x10(%ebp),%eax
801045e8:	7c ab                	jl     80104595 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801045ea:	8b 45 08             	mov    0x8(%ebp),%eax
801045ed:	05 34 02 00 00       	add    $0x234,%eax
801045f2:	83 ec 0c             	sub    $0xc,%esp
801045f5:	50                   	push   %eax
801045f6:	e8 db 0a 00 00       	call   801050d6 <wakeup>
801045fb:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801045fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104601:	83 ec 0c             	sub    $0xc,%esp
80104604:	50                   	push   %eax
80104605:	e8 47 0d 00 00       	call   80105351 <release>
8010460a:	83 c4 10             	add    $0x10,%esp
  return n;
8010460d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104610:	c9                   	leave  
80104611:	c3                   	ret    

80104612 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104612:	55                   	push   %ebp
80104613:	89 e5                	mov    %esp,%ebp
80104615:	53                   	push   %ebx
80104616:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104619:	8b 45 08             	mov    0x8(%ebp),%eax
8010461c:	83 ec 0c             	sub    $0xc,%esp
8010461f:	50                   	push   %eax
80104620:	e8 c5 0c 00 00       	call   801052ea <acquire>
80104625:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104628:	eb 3f                	jmp    80104669 <piperead+0x57>
    if(proc->killed){
8010462a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104630:	8b 40 24             	mov    0x24(%eax),%eax
80104633:	85 c0                	test   %eax,%eax
80104635:	74 19                	je     80104650 <piperead+0x3e>
      release(&p->lock);
80104637:	8b 45 08             	mov    0x8(%ebp),%eax
8010463a:	83 ec 0c             	sub    $0xc,%esp
8010463d:	50                   	push   %eax
8010463e:	e8 0e 0d 00 00       	call   80105351 <release>
80104643:	83 c4 10             	add    $0x10,%esp
      return -1;
80104646:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010464b:	e9 bf 00 00 00       	jmp    8010470f <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104650:	8b 45 08             	mov    0x8(%ebp),%eax
80104653:	8b 55 08             	mov    0x8(%ebp),%edx
80104656:	81 c2 34 02 00 00    	add    $0x234,%edx
8010465c:	83 ec 08             	sub    $0x8,%esp
8010465f:	50                   	push   %eax
80104660:	52                   	push   %edx
80104661:	e8 82 09 00 00       	call   80104fe8 <sleep>
80104666:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104669:	8b 45 08             	mov    0x8(%ebp),%eax
8010466c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104672:	8b 45 08             	mov    0x8(%ebp),%eax
80104675:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010467b:	39 c2                	cmp    %eax,%edx
8010467d:	75 0d                	jne    8010468c <piperead+0x7a>
8010467f:	8b 45 08             	mov    0x8(%ebp),%eax
80104682:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104688:	85 c0                	test   %eax,%eax
8010468a:	75 9e                	jne    8010462a <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010468c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104693:	eb 49                	jmp    801046de <piperead+0xcc>
    if(p->nread == p->nwrite)
80104695:	8b 45 08             	mov    0x8(%ebp),%eax
80104698:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010469e:	8b 45 08             	mov    0x8(%ebp),%eax
801046a1:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801046a7:	39 c2                	cmp    %eax,%edx
801046a9:	74 3d                	je     801046e8 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801046ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801046b1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801046b4:	8b 45 08             	mov    0x8(%ebp),%eax
801046b7:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801046bd:	8d 48 01             	lea    0x1(%eax),%ecx
801046c0:	8b 55 08             	mov    0x8(%ebp),%edx
801046c3:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801046c9:	25 ff 01 00 00       	and    $0x1ff,%eax
801046ce:	89 c2                	mov    %eax,%edx
801046d0:	8b 45 08             	mov    0x8(%ebp),%eax
801046d3:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801046d8:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801046da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801046de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e1:	3b 45 10             	cmp    0x10(%ebp),%eax
801046e4:	7c af                	jl     80104695 <piperead+0x83>
801046e6:	eb 01                	jmp    801046e9 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801046e8:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801046e9:	8b 45 08             	mov    0x8(%ebp),%eax
801046ec:	05 38 02 00 00       	add    $0x238,%eax
801046f1:	83 ec 0c             	sub    $0xc,%esp
801046f4:	50                   	push   %eax
801046f5:	e8 dc 09 00 00       	call   801050d6 <wakeup>
801046fa:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801046fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104700:	83 ec 0c             	sub    $0xc,%esp
80104703:	50                   	push   %eax
80104704:	e8 48 0c 00 00       	call   80105351 <release>
80104709:	83 c4 10             	add    $0x10,%esp
  return i;
8010470c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010470f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104712:	c9                   	leave  
80104713:	c3                   	ret    

80104714 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010471a:	9c                   	pushf  
8010471b:	58                   	pop    %eax
8010471c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010471f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104722:	c9                   	leave  
80104723:	c3                   	ret    

80104724 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104724:	55                   	push   %ebp
80104725:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104727:	fb                   	sti    
}
80104728:	90                   	nop
80104729:	5d                   	pop    %ebp
8010472a:	c3                   	ret    

8010472b <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010472b:	55                   	push   %ebp
8010472c:	89 e5                	mov    %esp,%ebp
8010472e:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104731:	83 ec 08             	sub    $0x8,%esp
80104734:	68 d9 90 10 80       	push   $0x801090d9
80104739:	68 80 3c 11 80       	push   $0x80113c80
8010473e:	e8 85 0b 00 00       	call   801052c8 <initlock>
80104743:	83 c4 10             	add    $0x10,%esp
}
80104746:	90                   	nop
80104747:	c9                   	leave  
80104748:	c3                   	ret    

80104749 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104749:	55                   	push   %ebp
8010474a:	89 e5                	mov    %esp,%ebp
8010474c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010474f:	83 ec 0c             	sub    $0xc,%esp
80104752:	68 80 3c 11 80       	push   $0x80113c80
80104757:	e8 8e 0b 00 00       	call   801052ea <acquire>
8010475c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010475f:	c7 45 f4 b4 3c 11 80 	movl   $0x80113cb4,-0xc(%ebp)
80104766:	eb 11                	jmp    80104779 <allocproc+0x30>
    if(p->state == UNUSED)
80104768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476b:	8b 40 0c             	mov    0xc(%eax),%eax
8010476e:	85 c0                	test   %eax,%eax
80104770:	74 2a                	je     8010479c <allocproc+0x53>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104772:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104779:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
80104780:	72 e6                	jb     80104768 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104782:	83 ec 0c             	sub    $0xc,%esp
80104785:	68 80 3c 11 80       	push   $0x80113c80
8010478a:	e8 c2 0b 00 00       	call   80105351 <release>
8010478f:	83 c4 10             	add    $0x10,%esp
  return 0;
80104792:	b8 00 00 00 00       	mov    $0x0,%eax
80104797:	e9 b4 00 00 00       	jmp    80104850 <allocproc+0x107>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
8010479c:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010479d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a0:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801047a7:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801047ac:	8d 50 01             	lea    0x1(%eax),%edx
801047af:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801047b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047b8:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
801047bb:	83 ec 0c             	sub    $0xc,%esp
801047be:	68 80 3c 11 80       	push   $0x80113c80
801047c3:	e8 89 0b 00 00       	call   80105351 <release>
801047c8:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801047cb:	e8 6c e7 ff ff       	call   80102f3c <kalloc>
801047d0:	89 c2                	mov    %eax,%edx
801047d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d5:	89 50 08             	mov    %edx,0x8(%eax)
801047d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047db:	8b 40 08             	mov    0x8(%eax),%eax
801047de:	85 c0                	test   %eax,%eax
801047e0:	75 11                	jne    801047f3 <allocproc+0xaa>
    p->state = UNUSED;
801047e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801047ec:	b8 00 00 00 00       	mov    $0x0,%eax
801047f1:	eb 5d                	jmp    80104850 <allocproc+0x107>
  }
  sp = p->kstack + KSTACKSIZE;
801047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f6:	8b 40 08             	mov    0x8(%eax),%eax
801047f9:	05 00 10 00 00       	add    $0x1000,%eax
801047fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104801:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104808:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010480b:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010480e:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104812:	ba af 6e 10 80       	mov    $0x80106eaf,%edx
80104817:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010481a:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010481c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104823:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104826:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010482f:	83 ec 04             	sub    $0x4,%esp
80104832:	6a 14                	push   $0x14
80104834:	6a 00                	push   $0x0
80104836:	50                   	push   %eax
80104837:	e8 11 0d 00 00       	call   8010554d <memset>
8010483c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010483f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104842:	8b 40 1c             	mov    0x1c(%eax),%eax
80104845:	ba a2 4f 10 80       	mov    $0x80104fa2,%edx
8010484a:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010484d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104850:	c9                   	leave  
80104851:	c3                   	ret    

80104852 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104852:	55                   	push   %ebp
80104853:	89 e5                	mov    %esp,%ebp
80104855:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104858:	e8 ec fe ff ff       	call   80104749 <allocproc>
8010485d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104863:	a3 88 c6 10 80       	mov    %eax,0x8010c688
  if((p->pgdir = setupkvm()) == 0)
80104868:	e8 07 3d 00 00       	call   80108574 <setupkvm>
8010486d:	89 c2                	mov    %eax,%edx
8010486f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104872:	89 50 04             	mov    %edx,0x4(%eax)
80104875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104878:	8b 40 04             	mov    0x4(%eax),%eax
8010487b:	85 c0                	test   %eax,%eax
8010487d:	75 0d                	jne    8010488c <userinit+0x3a>
    panic("userinit: out of memory?");
8010487f:	83 ec 0c             	sub    $0xc,%esp
80104882:	68 e0 90 10 80       	push   $0x801090e0
80104887:	e8 da bc ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010488c:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104894:	8b 40 04             	mov    0x4(%eax),%eax
80104897:	83 ec 04             	sub    $0x4,%esp
8010489a:	52                   	push   %edx
8010489b:	68 20 c5 10 80       	push   $0x8010c520
801048a0:	50                   	push   %eax
801048a1:	e8 28 3f 00 00       	call   801087ce <inituvm>
801048a6:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801048a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ac:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801048b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b5:	8b 40 18             	mov    0x18(%eax),%eax
801048b8:	83 ec 04             	sub    $0x4,%esp
801048bb:	6a 4c                	push   $0x4c
801048bd:	6a 00                	push   $0x0
801048bf:	50                   	push   %eax
801048c0:	e8 88 0c 00 00       	call   8010554d <memset>
801048c5:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801048c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048cb:	8b 40 18             	mov    0x18(%eax),%eax
801048ce:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d7:	8b 40 18             	mov    0x18(%eax),%eax
801048da:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801048e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e3:	8b 40 18             	mov    0x18(%eax),%eax
801048e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048e9:	8b 52 18             	mov    0x18(%edx),%edx
801048ec:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801048f0:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801048f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f7:	8b 40 18             	mov    0x18(%eax),%eax
801048fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048fd:	8b 52 18             	mov    0x18(%edx),%edx
80104900:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104904:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490b:	8b 40 18             	mov    0x18(%eax),%eax
8010490e:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104915:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104918:	8b 40 18             	mov    0x18(%eax),%eax
8010491b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104925:	8b 40 18             	mov    0x18(%eax),%eax
80104928:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010492f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104932:	83 c0 6c             	add    $0x6c,%eax
80104935:	83 ec 04             	sub    $0x4,%esp
80104938:	6a 10                	push   $0x10
8010493a:	68 f9 90 10 80       	push   $0x801090f9
8010493f:	50                   	push   %eax
80104940:	e8 0b 0e 00 00       	call   80105750 <safestrcpy>
80104945:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	68 02 91 10 80       	push   $0x80109102
80104950:	e8 a9 de ff ff       	call   801027fe <namei>
80104955:	83 c4 10             	add    $0x10,%esp
80104958:	89 c2                	mov    %eax,%edx
8010495a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495d:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104960:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104963:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010496a:	90                   	nop
8010496b:	c9                   	leave  
8010496c:	c3                   	ret    

8010496d <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010496d:	55                   	push   %ebp
8010496e:	89 e5                	mov    %esp,%ebp
80104970:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104973:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104979:	8b 00                	mov    (%eax),%eax
8010497b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010497e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104982:	7e 31                	jle    801049b5 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104984:	8b 55 08             	mov    0x8(%ebp),%edx
80104987:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010498a:	01 c2                	add    %eax,%edx
8010498c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104992:	8b 40 04             	mov    0x4(%eax),%eax
80104995:	83 ec 04             	sub    $0x4,%esp
80104998:	52                   	push   %edx
80104999:	ff 75 f4             	pushl  -0xc(%ebp)
8010499c:	50                   	push   %eax
8010499d:	e8 79 3f 00 00       	call   8010891b <allocuvm>
801049a2:	83 c4 10             	add    $0x10,%esp
801049a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801049a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049ac:	75 3e                	jne    801049ec <growproc+0x7f>
      return -1;
801049ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b3:	eb 59                	jmp    80104a0e <growproc+0xa1>
  } else if(n < 0){
801049b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801049b9:	79 31                	jns    801049ec <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801049bb:	8b 55 08             	mov    0x8(%ebp),%edx
801049be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c1:	01 c2                	add    %eax,%edx
801049c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c9:	8b 40 04             	mov    0x4(%eax),%eax
801049cc:	83 ec 04             	sub    $0x4,%esp
801049cf:	52                   	push   %edx
801049d0:	ff 75 f4             	pushl  -0xc(%ebp)
801049d3:	50                   	push   %eax
801049d4:	e8 0b 40 00 00       	call   801089e4 <deallocuvm>
801049d9:	83 c4 10             	add    $0x10,%esp
801049dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801049df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049e3:	75 07                	jne    801049ec <growproc+0x7f>
      return -1;
801049e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ea:	eb 22                	jmp    80104a0e <growproc+0xa1>
  }
  proc->sz = sz;
801049ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049f5:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801049f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049fd:	83 ec 0c             	sub    $0xc,%esp
80104a00:	50                   	push   %eax
80104a01:	e8 55 3c 00 00       	call   8010865b <switchuvm>
80104a06:	83 c4 10             	add    $0x10,%esp
  return 0;
80104a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a0e:	c9                   	leave  
80104a0f:	c3                   	ret    

80104a10 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	56                   	push   %esi
80104a15:	53                   	push   %ebx
80104a16:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104a19:	e8 2b fd ff ff       	call   80104749 <allocproc>
80104a1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104a21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104a25:	75 0a                	jne    80104a31 <fork+0x21>
    return -1;
80104a27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a2c:	e9 68 01 00 00       	jmp    80104b99 <fork+0x189>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104a31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a37:	8b 10                	mov    (%eax),%edx
80104a39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a3f:	8b 40 04             	mov    0x4(%eax),%eax
80104a42:	83 ec 08             	sub    $0x8,%esp
80104a45:	52                   	push   %edx
80104a46:	50                   	push   %eax
80104a47:	e8 36 41 00 00       	call   80108b82 <copyuvm>
80104a4c:	83 c4 10             	add    $0x10,%esp
80104a4f:	89 c2                	mov    %eax,%edx
80104a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a54:	89 50 04             	mov    %edx,0x4(%eax)
80104a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a5a:	8b 40 04             	mov    0x4(%eax),%eax
80104a5d:	85 c0                	test   %eax,%eax
80104a5f:	75 30                	jne    80104a91 <fork+0x81>
    kfree(np->kstack);
80104a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a64:	8b 40 08             	mov    0x8(%eax),%eax
80104a67:	83 ec 0c             	sub    $0xc,%esp
80104a6a:	50                   	push   %eax
80104a6b:	e8 2f e4 ff ff       	call   80102e9f <kfree>
80104a70:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a80:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104a87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a8c:	e9 08 01 00 00       	jmp    80104b99 <fork+0x189>
  }
  np->sz = proc->sz;
80104a91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a97:	8b 10                	mov    (%eax),%edx
80104a99:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a9c:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104a9e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104aa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aa8:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aae:	8b 50 18             	mov    0x18(%eax),%edx
80104ab1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab7:	8b 40 18             	mov    0x18(%eax),%eax
80104aba:	89 c3                	mov    %eax,%ebx
80104abc:	b8 13 00 00 00       	mov    $0x13,%eax
80104ac1:	89 d7                	mov    %edx,%edi
80104ac3:	89 de                	mov    %ebx,%esi
80104ac5:	89 c1                	mov    %eax,%ecx
80104ac7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104acc:	8b 40 18             	mov    0x18(%eax),%eax
80104acf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104ad6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104add:	eb 43                	jmp    80104b22 <fork+0x112>
    if(proc->ofile[i])
80104adf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104ae8:	83 c2 08             	add    $0x8,%edx
80104aeb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104aef:	85 c0                	test   %eax,%eax
80104af1:	74 2b                	je     80104b1e <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104af3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104afc:	83 c2 08             	add    $0x8,%edx
80104aff:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b03:	83 ec 0c             	sub    $0xc,%esp
80104b06:	50                   	push   %eax
80104b07:	e8 8f c6 ff ff       	call   8010119b <filedup>
80104b0c:	83 c4 10             	add    $0x10,%esp
80104b0f:	89 c1                	mov    %eax,%ecx
80104b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b17:	83 c2 08             	add    $0x8,%edx
80104b1a:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104b1e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b22:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b26:	7e b7                	jle    80104adf <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104b28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b2e:	8b 40 68             	mov    0x68(%eax),%eax
80104b31:	83 ec 0c             	sub    $0xc,%esp
80104b34:	50                   	push   %eax
80104b35:	e8 cc d0 ff ff       	call   80101c06 <idup>
80104b3a:	83 c4 10             	add    $0x10,%esp
80104b3d:	89 c2                	mov    %eax,%edx
80104b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b42:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104b45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b4b:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b51:	83 c0 6c             	add    $0x6c,%eax
80104b54:	83 ec 04             	sub    $0x4,%esp
80104b57:	6a 10                	push   $0x10
80104b59:	52                   	push   %edx
80104b5a:	50                   	push   %eax
80104b5b:	e8 f0 0b 00 00       	call   80105750 <safestrcpy>
80104b60:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104b63:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b66:	8b 40 10             	mov    0x10(%eax),%eax
80104b69:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104b6c:	83 ec 0c             	sub    $0xc,%esp
80104b6f:	68 80 3c 11 80       	push   $0x80113c80
80104b74:	e8 71 07 00 00       	call   801052ea <acquire>
80104b79:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104b7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b7f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104b86:	83 ec 0c             	sub    $0xc,%esp
80104b89:	68 80 3c 11 80       	push   $0x80113c80
80104b8e:	e8 be 07 00 00       	call   80105351 <release>
80104b93:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104b96:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b9c:	5b                   	pop    %ebx
80104b9d:	5e                   	pop    %esi
80104b9e:	5f                   	pop    %edi
80104b9f:	5d                   	pop    %ebp
80104ba0:	c3                   	ret    

80104ba1 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104ba1:	55                   	push   %ebp
80104ba2:	89 e5                	mov    %esp,%ebp
80104ba4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104ba7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bae:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80104bb3:	39 c2                	cmp    %eax,%edx
80104bb5:	75 0d                	jne    80104bc4 <exit+0x23>
    panic("init exiting");
80104bb7:	83 ec 0c             	sub    $0xc,%esp
80104bba:	68 04 91 10 80       	push   $0x80109104
80104bbf:	e8 a2 b9 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104bc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104bcb:	eb 48                	jmp    80104c15 <exit+0x74>
    if(proc->ofile[fd]){
80104bcd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bd6:	83 c2 08             	add    $0x8,%edx
80104bd9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104bdd:	85 c0                	test   %eax,%eax
80104bdf:	74 30                	je     80104c11 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104be1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104be7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bea:	83 c2 08             	add    $0x8,%edx
80104bed:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104bf1:	83 ec 0c             	sub    $0xc,%esp
80104bf4:	50                   	push   %eax
80104bf5:	e8 f2 c5 ff ff       	call   801011ec <fileclose>
80104bfa:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104bfd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c06:	83 c2 08             	add    $0x8,%edx
80104c09:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c10:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c11:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c15:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c19:	7e b2                	jle    80104bcd <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104c1b:	e8 03 ec ff ff       	call   80103823 <begin_op>
  iput(proc->cwd);
80104c20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c26:	8b 40 68             	mov    0x68(%eax),%eax
80104c29:	83 ec 0c             	sub    $0xc,%esp
80104c2c:	50                   	push   %eax
80104c2d:	e8 de d1 ff ff       	call   80101e10 <iput>
80104c32:	83 c4 10             	add    $0x10,%esp
  end_op();
80104c35:	e8 75 ec ff ff       	call   801038af <end_op>
  proc->cwd = 0;
80104c3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c40:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104c47:	83 ec 0c             	sub    $0xc,%esp
80104c4a:	68 80 3c 11 80       	push   $0x80113c80
80104c4f:	e8 96 06 00 00       	call   801052ea <acquire>
80104c54:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104c57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c5d:	8b 40 14             	mov    0x14(%eax),%eax
80104c60:	83 ec 0c             	sub    $0xc,%esp
80104c63:	50                   	push   %eax
80104c64:	e8 2b 04 00 00       	call   80105094 <wakeup1>
80104c69:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c6c:	c7 45 f4 b4 3c 11 80 	movl   $0x80113cb4,-0xc(%ebp)
80104c73:	eb 3f                	jmp    80104cb4 <exit+0x113>
    if(p->parent == proc){
80104c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c78:	8b 50 14             	mov    0x14(%eax),%edx
80104c7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c81:	39 c2                	cmp    %eax,%edx
80104c83:	75 28                	jne    80104cad <exit+0x10c>
      p->parent = initproc;
80104c85:	8b 15 88 c6 10 80    	mov    0x8010c688,%edx
80104c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8e:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c94:	8b 40 0c             	mov    0xc(%eax),%eax
80104c97:	83 f8 05             	cmp    $0x5,%eax
80104c9a:	75 11                	jne    80104cad <exit+0x10c>
        wakeup1(initproc);
80104c9c:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80104ca1:	83 ec 0c             	sub    $0xc,%esp
80104ca4:	50                   	push   %eax
80104ca5:	e8 ea 03 00 00       	call   80105094 <wakeup1>
80104caa:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cad:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104cb4:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
80104cbb:	72 b8                	jb     80104c75 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104cbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc3:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104cca:	e8 dc 01 00 00       	call   80104eab <sched>
  panic("zombie exit");
80104ccf:	83 ec 0c             	sub    $0xc,%esp
80104cd2:	68 11 91 10 80       	push   $0x80109111
80104cd7:	e8 8a b8 ff ff       	call   80100566 <panic>

80104cdc <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104cdc:	55                   	push   %ebp
80104cdd:	89 e5                	mov    %esp,%ebp
80104cdf:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104ce2:	83 ec 0c             	sub    $0xc,%esp
80104ce5:	68 80 3c 11 80       	push   $0x80113c80
80104cea:	e8 fb 05 00 00       	call   801052ea <acquire>
80104cef:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104cf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cf9:	c7 45 f4 b4 3c 11 80 	movl   $0x80113cb4,-0xc(%ebp)
80104d00:	e9 a9 00 00 00       	jmp    80104dae <wait+0xd2>
      if(p->parent != proc)
80104d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d08:	8b 50 14             	mov    0x14(%eax),%edx
80104d0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d11:	39 c2                	cmp    %eax,%edx
80104d13:	0f 85 8d 00 00 00    	jne    80104da6 <wait+0xca>
        continue;
      havekids = 1;
80104d19:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d23:	8b 40 0c             	mov    0xc(%eax),%eax
80104d26:	83 f8 05             	cmp    $0x5,%eax
80104d29:	75 7c                	jne    80104da7 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d2e:	8b 40 10             	mov    0x10(%eax),%eax
80104d31:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d37:	8b 40 08             	mov    0x8(%eax),%eax
80104d3a:	83 ec 0c             	sub    $0xc,%esp
80104d3d:	50                   	push   %eax
80104d3e:	e8 5c e1 ff ff       	call   80102e9f <kfree>
80104d43:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d53:	8b 40 04             	mov    0x4(%eax),%eax
80104d56:	83 ec 0c             	sub    $0xc,%esp
80104d59:	50                   	push   %eax
80104d5a:	e8 42 3d 00 00       	call   80108aa1 <freevm>
80104d5f:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d79:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d83:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d8a:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104d91:	83 ec 0c             	sub    $0xc,%esp
80104d94:	68 80 3c 11 80       	push   $0x80113c80
80104d99:	e8 b3 05 00 00       	call   80105351 <release>
80104d9e:	83 c4 10             	add    $0x10,%esp
        return pid;
80104da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104da4:	eb 5b                	jmp    80104e01 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104da6:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104da7:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104dae:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
80104db5:	0f 82 4a ff ff ff    	jb     80104d05 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104dbf:	74 0d                	je     80104dce <wait+0xf2>
80104dc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc7:	8b 40 24             	mov    0x24(%eax),%eax
80104dca:	85 c0                	test   %eax,%eax
80104dcc:	74 17                	je     80104de5 <wait+0x109>
      release(&ptable.lock);
80104dce:	83 ec 0c             	sub    $0xc,%esp
80104dd1:	68 80 3c 11 80       	push   $0x80113c80
80104dd6:	e8 76 05 00 00       	call   80105351 <release>
80104ddb:	83 c4 10             	add    $0x10,%esp
      return -1;
80104dde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de3:	eb 1c                	jmp    80104e01 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104de5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104deb:	83 ec 08             	sub    $0x8,%esp
80104dee:	68 80 3c 11 80       	push   $0x80113c80
80104df3:	50                   	push   %eax
80104df4:	e8 ef 01 00 00       	call   80104fe8 <sleep>
80104df9:	83 c4 10             	add    $0x10,%esp
  }
80104dfc:	e9 f1 fe ff ff       	jmp    80104cf2 <wait+0x16>
}
80104e01:	c9                   	leave  
80104e02:	c3                   	ret    

80104e03 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104e03:	55                   	push   %ebp
80104e04:	89 e5                	mov    %esp,%ebp
80104e06:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104e09:	e8 16 f9 ff ff       	call   80104724 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104e0e:	83 ec 0c             	sub    $0xc,%esp
80104e11:	68 80 3c 11 80       	push   $0x80113c80
80104e16:	e8 cf 04 00 00       	call   801052ea <acquire>
80104e1b:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e1e:	c7 45 f4 b4 3c 11 80 	movl   $0x80113cb4,-0xc(%ebp)
80104e25:	eb 66                	jmp    80104e8d <scheduler+0x8a>
      if(p->state != RUNNABLE)
80104e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e2a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e2d:	83 f8 03             	cmp    $0x3,%eax
80104e30:	75 53                	jne    80104e85 <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e35:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104e3b:	83 ec 0c             	sub    $0xc,%esp
80104e3e:	ff 75 f4             	pushl  -0xc(%ebp)
80104e41:	e8 15 38 00 00       	call   8010865b <switchuvm>
80104e46:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e4c:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104e53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e59:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e5c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104e63:	83 c2 04             	add    $0x4,%edx
80104e66:	83 ec 08             	sub    $0x8,%esp
80104e69:	50                   	push   %eax
80104e6a:	52                   	push   %edx
80104e6b:	e8 51 09 00 00       	call   801057c1 <swtch>
80104e70:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104e73:	e8 c6 37 00 00       	call   8010863e <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104e78:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104e7f:	00 00 00 00 
80104e83:	eb 01                	jmp    80104e86 <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104e85:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e86:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104e8d:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
80104e94:	72 91                	jb     80104e27 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104e96:	83 ec 0c             	sub    $0xc,%esp
80104e99:	68 80 3c 11 80       	push   $0x80113c80
80104e9e:	e8 ae 04 00 00       	call   80105351 <release>
80104ea3:	83 c4 10             	add    $0x10,%esp

  }
80104ea6:	e9 5e ff ff ff       	jmp    80104e09 <scheduler+0x6>

80104eab <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104eab:	55                   	push   %ebp
80104eac:	89 e5                	mov    %esp,%ebp
80104eae:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104eb1:	83 ec 0c             	sub    $0xc,%esp
80104eb4:	68 80 3c 11 80       	push   $0x80113c80
80104eb9:	e8 5f 05 00 00       	call   8010541d <holding>
80104ebe:	83 c4 10             	add    $0x10,%esp
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	75 0d                	jne    80104ed2 <sched+0x27>
    panic("sched ptable.lock");
80104ec5:	83 ec 0c             	sub    $0xc,%esp
80104ec8:	68 1d 91 10 80       	push   $0x8010911d
80104ecd:	e8 94 b6 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104ed2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ed8:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104ede:	83 f8 01             	cmp    $0x1,%eax
80104ee1:	74 0d                	je     80104ef0 <sched+0x45>
    panic("sched locks");
80104ee3:	83 ec 0c             	sub    $0xc,%esp
80104ee6:	68 2f 91 10 80       	push   $0x8010912f
80104eeb:	e8 76 b6 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104ef0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ef6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ef9:	83 f8 04             	cmp    $0x4,%eax
80104efc:	75 0d                	jne    80104f0b <sched+0x60>
    panic("sched running");
80104efe:	83 ec 0c             	sub    $0xc,%esp
80104f01:	68 3b 91 10 80       	push   $0x8010913b
80104f06:	e8 5b b6 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104f0b:	e8 04 f8 ff ff       	call   80104714 <readeflags>
80104f10:	25 00 02 00 00       	and    $0x200,%eax
80104f15:	85 c0                	test   %eax,%eax
80104f17:	74 0d                	je     80104f26 <sched+0x7b>
    panic("sched interruptible");
80104f19:	83 ec 0c             	sub    $0xc,%esp
80104f1c:	68 49 91 10 80       	push   $0x80109149
80104f21:	e8 40 b6 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104f26:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f2c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104f35:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f3b:	8b 40 04             	mov    0x4(%eax),%eax
80104f3e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f45:	83 c2 1c             	add    $0x1c,%edx
80104f48:	83 ec 08             	sub    $0x8,%esp
80104f4b:	50                   	push   %eax
80104f4c:	52                   	push   %edx
80104f4d:	e8 6f 08 00 00       	call   801057c1 <swtch>
80104f52:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104f55:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f5e:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104f64:	90                   	nop
80104f65:	c9                   	leave  
80104f66:	c3                   	ret    

80104f67 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104f67:	55                   	push   %ebp
80104f68:	89 e5                	mov    %esp,%ebp
80104f6a:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104f6d:	83 ec 0c             	sub    $0xc,%esp
80104f70:	68 80 3c 11 80       	push   $0x80113c80
80104f75:	e8 70 03 00 00       	call   801052ea <acquire>
80104f7a:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104f7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f83:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104f8a:	e8 1c ff ff ff       	call   80104eab <sched>
  release(&ptable.lock);
80104f8f:	83 ec 0c             	sub    $0xc,%esp
80104f92:	68 80 3c 11 80       	push   $0x80113c80
80104f97:	e8 b5 03 00 00       	call   80105351 <release>
80104f9c:	83 c4 10             	add    $0x10,%esp
}
80104f9f:	90                   	nop
80104fa0:	c9                   	leave  
80104fa1:	c3                   	ret    

80104fa2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104fa2:	55                   	push   %ebp
80104fa3:	89 e5                	mov    %esp,%ebp
80104fa5:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	68 80 3c 11 80       	push   $0x80113c80
80104fb0:	e8 9c 03 00 00       	call   80105351 <release>
80104fb5:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104fb8:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104fbd:	85 c0                	test   %eax,%eax
80104fbf:	74 24                	je     80104fe5 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104fc1:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104fc8:	00 00 00 
    iinit(ROOTDEV);
80104fcb:	83 ec 0c             	sub    $0xc,%esp
80104fce:	6a 01                	push   $0x1
80104fd0:	e8 3f c9 ff ff       	call   80101914 <iinit>
80104fd5:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104fd8:	83 ec 0c             	sub    $0xc,%esp
80104fdb:	6a 01                	push   $0x1
80104fdd:	e8 23 e6 ff ff       	call   80103605 <initlog>
80104fe2:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104fe5:	90                   	nop
80104fe6:	c9                   	leave  
80104fe7:	c3                   	ret    

80104fe8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104fe8:	55                   	push   %ebp
80104fe9:	89 e5                	mov    %esp,%ebp
80104feb:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104fee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ff4:	85 c0                	test   %eax,%eax
80104ff6:	75 0d                	jne    80105005 <sleep+0x1d>
    panic("sleep");
80104ff8:	83 ec 0c             	sub    $0xc,%esp
80104ffb:	68 5d 91 10 80       	push   $0x8010915d
80105000:	e8 61 b5 ff ff       	call   80100566 <panic>

  if(lk == 0)
80105005:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105009:	75 0d                	jne    80105018 <sleep+0x30>
    panic("sleep without lk");
8010500b:	83 ec 0c             	sub    $0xc,%esp
8010500e:	68 63 91 10 80       	push   $0x80109163
80105013:	e8 4e b5 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105018:	81 7d 0c 80 3c 11 80 	cmpl   $0x80113c80,0xc(%ebp)
8010501f:	74 1e                	je     8010503f <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105021:	83 ec 0c             	sub    $0xc,%esp
80105024:	68 80 3c 11 80       	push   $0x80113c80
80105029:	e8 bc 02 00 00       	call   801052ea <acquire>
8010502e:	83 c4 10             	add    $0x10,%esp
    release(lk);
80105031:	83 ec 0c             	sub    $0xc,%esp
80105034:	ff 75 0c             	pushl  0xc(%ebp)
80105037:	e8 15 03 00 00       	call   80105351 <release>
8010503c:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
8010503f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105045:	8b 55 08             	mov    0x8(%ebp),%edx
80105048:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
8010504b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105051:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80105058:	e8 4e fe ff ff       	call   80104eab <sched>

  // Tidy up.
  proc->chan = 0;
8010505d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105063:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010506a:	81 7d 0c 80 3c 11 80 	cmpl   $0x80113c80,0xc(%ebp)
80105071:	74 1e                	je     80105091 <sleep+0xa9>
    release(&ptable.lock);
80105073:	83 ec 0c             	sub    $0xc,%esp
80105076:	68 80 3c 11 80       	push   $0x80113c80
8010507b:	e8 d1 02 00 00       	call   80105351 <release>
80105080:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80105083:	83 ec 0c             	sub    $0xc,%esp
80105086:	ff 75 0c             	pushl  0xc(%ebp)
80105089:	e8 5c 02 00 00       	call   801052ea <acquire>
8010508e:	83 c4 10             	add    $0x10,%esp
  }
}
80105091:	90                   	nop
80105092:	c9                   	leave  
80105093:	c3                   	ret    

80105094 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010509a:	c7 45 fc b4 3c 11 80 	movl   $0x80113cb4,-0x4(%ebp)
801050a1:	eb 27                	jmp    801050ca <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
801050a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050a6:	8b 40 0c             	mov    0xc(%eax),%eax
801050a9:	83 f8 02             	cmp    $0x2,%eax
801050ac:	75 15                	jne    801050c3 <wakeup1+0x2f>
801050ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050b1:	8b 40 20             	mov    0x20(%eax),%eax
801050b4:	3b 45 08             	cmp    0x8(%ebp),%eax
801050b7:	75 0a                	jne    801050c3 <wakeup1+0x2f>
      p->state = RUNNABLE;
801050b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050c3:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
801050ca:	81 7d fc b4 5d 11 80 	cmpl   $0x80115db4,-0x4(%ebp)
801050d1:	72 d0                	jb     801050a3 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
801050d3:	90                   	nop
801050d4:	c9                   	leave  
801050d5:	c3                   	ret    

801050d6 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801050d6:	55                   	push   %ebp
801050d7:	89 e5                	mov    %esp,%ebp
801050d9:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801050dc:	83 ec 0c             	sub    $0xc,%esp
801050df:	68 80 3c 11 80       	push   $0x80113c80
801050e4:	e8 01 02 00 00       	call   801052ea <acquire>
801050e9:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801050ec:	83 ec 0c             	sub    $0xc,%esp
801050ef:	ff 75 08             	pushl  0x8(%ebp)
801050f2:	e8 9d ff ff ff       	call   80105094 <wakeup1>
801050f7:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801050fa:	83 ec 0c             	sub    $0xc,%esp
801050fd:	68 80 3c 11 80       	push   $0x80113c80
80105102:	e8 4a 02 00 00       	call   80105351 <release>
80105107:	83 c4 10             	add    $0x10,%esp
}
8010510a:	90                   	nop
8010510b:	c9                   	leave  
8010510c:	c3                   	ret    

8010510d <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010510d:	55                   	push   %ebp
8010510e:	89 e5                	mov    %esp,%ebp
80105110:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80105113:	83 ec 0c             	sub    $0xc,%esp
80105116:	68 80 3c 11 80       	push   $0x80113c80
8010511b:	e8 ca 01 00 00       	call   801052ea <acquire>
80105120:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105123:	c7 45 f4 b4 3c 11 80 	movl   $0x80113cb4,-0xc(%ebp)
8010512a:	eb 48                	jmp    80105174 <kill+0x67>
    if(p->pid == pid){
8010512c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010512f:	8b 40 10             	mov    0x10(%eax),%eax
80105132:	3b 45 08             	cmp    0x8(%ebp),%eax
80105135:	75 36                	jne    8010516d <kill+0x60>
      p->killed = 1;
80105137:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010513a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105141:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105144:	8b 40 0c             	mov    0xc(%eax),%eax
80105147:	83 f8 02             	cmp    $0x2,%eax
8010514a:	75 0a                	jne    80105156 <kill+0x49>
        p->state = RUNNABLE;
8010514c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105156:	83 ec 0c             	sub    $0xc,%esp
80105159:	68 80 3c 11 80       	push   $0x80113c80
8010515e:	e8 ee 01 00 00       	call   80105351 <release>
80105163:	83 c4 10             	add    $0x10,%esp
      return 0;
80105166:	b8 00 00 00 00       	mov    $0x0,%eax
8010516b:	eb 25                	jmp    80105192 <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010516d:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80105174:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
8010517b:	72 af                	jb     8010512c <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
8010517d:	83 ec 0c             	sub    $0xc,%esp
80105180:	68 80 3c 11 80       	push   $0x80113c80
80105185:	e8 c7 01 00 00       	call   80105351 <release>
8010518a:	83 c4 10             	add    $0x10,%esp
  return -1;
8010518d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105192:	c9                   	leave  
80105193:	c3                   	ret    

80105194 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105194:	55                   	push   %ebp
80105195:	89 e5                	mov    %esp,%ebp
80105197:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010519a:	c7 45 f0 b4 3c 11 80 	movl   $0x80113cb4,-0x10(%ebp)
801051a1:	e9 da 00 00 00       	jmp    80105280 <procdump+0xec>
    if(p->state == UNUSED)
801051a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051a9:	8b 40 0c             	mov    0xc(%eax),%eax
801051ac:	85 c0                	test   %eax,%eax
801051ae:	0f 84 c4 00 00 00    	je     80105278 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801051b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051b7:	8b 40 0c             	mov    0xc(%eax),%eax
801051ba:	83 f8 05             	cmp    $0x5,%eax
801051bd:	77 23                	ja     801051e2 <procdump+0x4e>
801051bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051c2:	8b 40 0c             	mov    0xc(%eax),%eax
801051c5:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801051cc:	85 c0                	test   %eax,%eax
801051ce:	74 12                	je     801051e2 <procdump+0x4e>
      state = states[p->state];
801051d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051d3:	8b 40 0c             	mov    0xc(%eax),%eax
801051d6:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801051dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
801051e0:	eb 07                	jmp    801051e9 <procdump+0x55>
    else
      state = "???";
801051e2:	c7 45 ec 74 91 10 80 	movl   $0x80109174,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801051e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051ec:	8d 50 6c             	lea    0x6c(%eax),%edx
801051ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051f2:	8b 40 10             	mov    0x10(%eax),%eax
801051f5:	52                   	push   %edx
801051f6:	ff 75 ec             	pushl  -0x14(%ebp)
801051f9:	50                   	push   %eax
801051fa:	68 78 91 10 80       	push   $0x80109178
801051ff:	e8 c2 b1 ff ff       	call   801003c6 <cprintf>
80105204:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105207:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010520a:	8b 40 0c             	mov    0xc(%eax),%eax
8010520d:	83 f8 02             	cmp    $0x2,%eax
80105210:	75 54                	jne    80105266 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105212:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105215:	8b 40 1c             	mov    0x1c(%eax),%eax
80105218:	8b 40 0c             	mov    0xc(%eax),%eax
8010521b:	83 c0 08             	add    $0x8,%eax
8010521e:	89 c2                	mov    %eax,%edx
80105220:	83 ec 08             	sub    $0x8,%esp
80105223:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105226:	50                   	push   %eax
80105227:	52                   	push   %edx
80105228:	e8 76 01 00 00       	call   801053a3 <getcallerpcs>
8010522d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105237:	eb 1c                	jmp    80105255 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80105239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010523c:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105240:	83 ec 08             	sub    $0x8,%esp
80105243:	50                   	push   %eax
80105244:	68 81 91 10 80       	push   $0x80109181
80105249:	e8 78 b1 ff ff       	call   801003c6 <cprintf>
8010524e:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105251:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105255:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105259:	7f 0b                	jg     80105266 <procdump+0xd2>
8010525b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010525e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105262:	85 c0                	test   %eax,%eax
80105264:	75 d3                	jne    80105239 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105266:	83 ec 0c             	sub    $0xc,%esp
80105269:	68 85 91 10 80       	push   $0x80109185
8010526e:	e8 53 b1 ff ff       	call   801003c6 <cprintf>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	eb 01                	jmp    80105279 <procdump+0xe5>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105278:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105279:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80105280:	81 7d f0 b4 5d 11 80 	cmpl   $0x80115db4,-0x10(%ebp)
80105287:	0f 82 19 ff ff ff    	jb     801051a6 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
8010528d:	90                   	nop
8010528e:	c9                   	leave  
8010528f:	c3                   	ret    

80105290 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105296:	9c                   	pushf  
80105297:	58                   	pop    %eax
80105298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010529b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010529e:	c9                   	leave  
8010529f:	c3                   	ret    

801052a0 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801052a3:	fa                   	cli    
}
801052a4:	90                   	nop
801052a5:	5d                   	pop    %ebp
801052a6:	c3                   	ret    

801052a7 <sti>:

static inline void
sti(void)
{
801052a7:	55                   	push   %ebp
801052a8:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801052aa:	fb                   	sti    
}
801052ab:	90                   	nop
801052ac:	5d                   	pop    %ebp
801052ad:	c3                   	ret    

801052ae <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801052ae:	55                   	push   %ebp
801052af:	89 e5                	mov    %esp,%ebp
801052b1:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801052b4:	8b 55 08             	mov    0x8(%ebp),%edx
801052b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052bd:	f0 87 02             	lock xchg %eax,(%edx)
801052c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801052c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052c6:	c9                   	leave  
801052c7:	c3                   	ret    

801052c8 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801052c8:	55                   	push   %ebp
801052c9:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801052cb:	8b 45 08             	mov    0x8(%ebp),%eax
801052ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801052d1:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801052d4:	8b 45 08             	mov    0x8(%ebp),%eax
801052d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801052dd:	8b 45 08             	mov    0x8(%ebp),%eax
801052e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801052e7:	90                   	nop
801052e8:	5d                   	pop    %ebp
801052e9:	c3                   	ret    

801052ea <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801052ea:	55                   	push   %ebp
801052eb:	89 e5                	mov    %esp,%ebp
801052ed:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801052f0:	e8 52 01 00 00       	call   80105447 <pushcli>
  if(holding(lk))
801052f5:	8b 45 08             	mov    0x8(%ebp),%eax
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	50                   	push   %eax
801052fc:	e8 1c 01 00 00       	call   8010541d <holding>
80105301:	83 c4 10             	add    $0x10,%esp
80105304:	85 c0                	test   %eax,%eax
80105306:	74 0d                	je     80105315 <acquire+0x2b>
    panic("acquire");
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	68 b1 91 10 80       	push   $0x801091b1
80105310:	e8 51 b2 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105315:	90                   	nop
80105316:	8b 45 08             	mov    0x8(%ebp),%eax
80105319:	83 ec 08             	sub    $0x8,%esp
8010531c:	6a 01                	push   $0x1
8010531e:	50                   	push   %eax
8010531f:	e8 8a ff ff ff       	call   801052ae <xchg>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	75 eb                	jne    80105316 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010532b:	8b 45 08             	mov    0x8(%ebp),%eax
8010532e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105335:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105338:	8b 45 08             	mov    0x8(%ebp),%eax
8010533b:	83 c0 0c             	add    $0xc,%eax
8010533e:	83 ec 08             	sub    $0x8,%esp
80105341:	50                   	push   %eax
80105342:	8d 45 08             	lea    0x8(%ebp),%eax
80105345:	50                   	push   %eax
80105346:	e8 58 00 00 00       	call   801053a3 <getcallerpcs>
8010534b:	83 c4 10             	add    $0x10,%esp
}
8010534e:	90                   	nop
8010534f:	c9                   	leave  
80105350:	c3                   	ret    

80105351 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105351:	55                   	push   %ebp
80105352:	89 e5                	mov    %esp,%ebp
80105354:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105357:	83 ec 0c             	sub    $0xc,%esp
8010535a:	ff 75 08             	pushl  0x8(%ebp)
8010535d:	e8 bb 00 00 00       	call   8010541d <holding>
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	85 c0                	test   %eax,%eax
80105367:	75 0d                	jne    80105376 <release+0x25>
    panic("release");
80105369:	83 ec 0c             	sub    $0xc,%esp
8010536c:	68 b9 91 10 80       	push   $0x801091b9
80105371:	e8 f0 b1 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105376:	8b 45 08             	mov    0x8(%ebp),%eax
80105379:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105380:	8b 45 08             	mov    0x8(%ebp),%eax
80105383:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010538a:	8b 45 08             	mov    0x8(%ebp),%eax
8010538d:	83 ec 08             	sub    $0x8,%esp
80105390:	6a 00                	push   $0x0
80105392:	50                   	push   %eax
80105393:	e8 16 ff ff ff       	call   801052ae <xchg>
80105398:	83 c4 10             	add    $0x10,%esp

  popcli();
8010539b:	e8 ec 00 00 00       	call   8010548c <popcli>
}
801053a0:	90                   	nop
801053a1:	c9                   	leave  
801053a2:	c3                   	ret    

801053a3 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801053a3:	55                   	push   %ebp
801053a4:	89 e5                	mov    %esp,%ebp
801053a6:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801053a9:	8b 45 08             	mov    0x8(%ebp),%eax
801053ac:	83 e8 08             	sub    $0x8,%eax
801053af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801053b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801053b9:	eb 38                	jmp    801053f3 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801053bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801053bf:	74 53                	je     80105414 <getcallerpcs+0x71>
801053c1:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801053c8:	76 4a                	jbe    80105414 <getcallerpcs+0x71>
801053ca:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801053ce:	74 44                	je     80105414 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801053d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053da:	8b 45 0c             	mov    0xc(%ebp),%eax
801053dd:	01 c2                	add    %eax,%edx
801053df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053e2:	8b 40 04             	mov    0x4(%eax),%eax
801053e5:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801053e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053ea:	8b 00                	mov    (%eax),%eax
801053ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801053ef:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053f3:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053f7:	7e c2                	jle    801053bb <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801053f9:	eb 19                	jmp    80105414 <getcallerpcs+0x71>
    pcs[i] = 0;
801053fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105405:	8b 45 0c             	mov    0xc(%ebp),%eax
80105408:	01 d0                	add    %edx,%eax
8010540a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105410:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105414:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105418:	7e e1                	jle    801053fb <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010541a:	90                   	nop
8010541b:	c9                   	leave  
8010541c:	c3                   	ret    

8010541d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010541d:	55                   	push   %ebp
8010541e:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105420:	8b 45 08             	mov    0x8(%ebp),%eax
80105423:	8b 00                	mov    (%eax),%eax
80105425:	85 c0                	test   %eax,%eax
80105427:	74 17                	je     80105440 <holding+0x23>
80105429:	8b 45 08             	mov    0x8(%ebp),%eax
8010542c:	8b 50 08             	mov    0x8(%eax),%edx
8010542f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105435:	39 c2                	cmp    %eax,%edx
80105437:	75 07                	jne    80105440 <holding+0x23>
80105439:	b8 01 00 00 00       	mov    $0x1,%eax
8010543e:	eb 05                	jmp    80105445 <holding+0x28>
80105440:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105445:	5d                   	pop    %ebp
80105446:	c3                   	ret    

80105447 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105447:	55                   	push   %ebp
80105448:	89 e5                	mov    %esp,%ebp
8010544a:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010544d:	e8 3e fe ff ff       	call   80105290 <readeflags>
80105452:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105455:	e8 46 fe ff ff       	call   801052a0 <cli>
  if(cpu->ncli++ == 0)
8010545a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105461:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105467:	8d 48 01             	lea    0x1(%eax),%ecx
8010546a:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105470:	85 c0                	test   %eax,%eax
80105472:	75 15                	jne    80105489 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105474:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010547a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010547d:	81 e2 00 02 00 00    	and    $0x200,%edx
80105483:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105489:	90                   	nop
8010548a:	c9                   	leave  
8010548b:	c3                   	ret    

8010548c <popcli>:

void
popcli(void)
{
8010548c:	55                   	push   %ebp
8010548d:	89 e5                	mov    %esp,%ebp
8010548f:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105492:	e8 f9 fd ff ff       	call   80105290 <readeflags>
80105497:	25 00 02 00 00       	and    $0x200,%eax
8010549c:	85 c0                	test   %eax,%eax
8010549e:	74 0d                	je     801054ad <popcli+0x21>
    panic("popcli - interruptible");
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	68 c1 91 10 80       	push   $0x801091c1
801054a8:	e8 b9 b0 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801054ad:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054b3:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801054b9:	83 ea 01             	sub    $0x1,%edx
801054bc:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801054c2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054c8:	85 c0                	test   %eax,%eax
801054ca:	79 0d                	jns    801054d9 <popcli+0x4d>
    panic("popcli");
801054cc:	83 ec 0c             	sub    $0xc,%esp
801054cf:	68 d8 91 10 80       	push   $0x801091d8
801054d4:	e8 8d b0 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801054d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054df:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054e5:	85 c0                	test   %eax,%eax
801054e7:	75 15                	jne    801054fe <popcli+0x72>
801054e9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054ef:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801054f5:	85 c0                	test   %eax,%eax
801054f7:	74 05                	je     801054fe <popcli+0x72>
    sti();
801054f9:	e8 a9 fd ff ff       	call   801052a7 <sti>
}
801054fe:	90                   	nop
801054ff:	c9                   	leave  
80105500:	c3                   	ret    

80105501 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105501:	55                   	push   %ebp
80105502:	89 e5                	mov    %esp,%ebp
80105504:	57                   	push   %edi
80105505:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105506:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105509:	8b 55 10             	mov    0x10(%ebp),%edx
8010550c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550f:	89 cb                	mov    %ecx,%ebx
80105511:	89 df                	mov    %ebx,%edi
80105513:	89 d1                	mov    %edx,%ecx
80105515:	fc                   	cld    
80105516:	f3 aa                	rep stos %al,%es:(%edi)
80105518:	89 ca                	mov    %ecx,%edx
8010551a:	89 fb                	mov    %edi,%ebx
8010551c:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010551f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105522:	90                   	nop
80105523:	5b                   	pop    %ebx
80105524:	5f                   	pop    %edi
80105525:	5d                   	pop    %ebp
80105526:	c3                   	ret    

80105527 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105527:	55                   	push   %ebp
80105528:	89 e5                	mov    %esp,%ebp
8010552a:	57                   	push   %edi
8010552b:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010552c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010552f:	8b 55 10             	mov    0x10(%ebp),%edx
80105532:	8b 45 0c             	mov    0xc(%ebp),%eax
80105535:	89 cb                	mov    %ecx,%ebx
80105537:	89 df                	mov    %ebx,%edi
80105539:	89 d1                	mov    %edx,%ecx
8010553b:	fc                   	cld    
8010553c:	f3 ab                	rep stos %eax,%es:(%edi)
8010553e:	89 ca                	mov    %ecx,%edx
80105540:	89 fb                	mov    %edi,%ebx
80105542:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105545:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105548:	90                   	nop
80105549:	5b                   	pop    %ebx
8010554a:	5f                   	pop    %edi
8010554b:	5d                   	pop    %ebp
8010554c:	c3                   	ret    

8010554d <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010554d:	55                   	push   %ebp
8010554e:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105550:	8b 45 08             	mov    0x8(%ebp),%eax
80105553:	83 e0 03             	and    $0x3,%eax
80105556:	85 c0                	test   %eax,%eax
80105558:	75 43                	jne    8010559d <memset+0x50>
8010555a:	8b 45 10             	mov    0x10(%ebp),%eax
8010555d:	83 e0 03             	and    $0x3,%eax
80105560:	85 c0                	test   %eax,%eax
80105562:	75 39                	jne    8010559d <memset+0x50>
    c &= 0xFF;
80105564:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010556b:	8b 45 10             	mov    0x10(%ebp),%eax
8010556e:	c1 e8 02             	shr    $0x2,%eax
80105571:	89 c1                	mov    %eax,%ecx
80105573:	8b 45 0c             	mov    0xc(%ebp),%eax
80105576:	c1 e0 18             	shl    $0x18,%eax
80105579:	89 c2                	mov    %eax,%edx
8010557b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010557e:	c1 e0 10             	shl    $0x10,%eax
80105581:	09 c2                	or     %eax,%edx
80105583:	8b 45 0c             	mov    0xc(%ebp),%eax
80105586:	c1 e0 08             	shl    $0x8,%eax
80105589:	09 d0                	or     %edx,%eax
8010558b:	0b 45 0c             	or     0xc(%ebp),%eax
8010558e:	51                   	push   %ecx
8010558f:	50                   	push   %eax
80105590:	ff 75 08             	pushl  0x8(%ebp)
80105593:	e8 8f ff ff ff       	call   80105527 <stosl>
80105598:	83 c4 0c             	add    $0xc,%esp
8010559b:	eb 12                	jmp    801055af <memset+0x62>
  } else
    stosb(dst, c, n);
8010559d:	8b 45 10             	mov    0x10(%ebp),%eax
801055a0:	50                   	push   %eax
801055a1:	ff 75 0c             	pushl  0xc(%ebp)
801055a4:	ff 75 08             	pushl  0x8(%ebp)
801055a7:	e8 55 ff ff ff       	call   80105501 <stosb>
801055ac:	83 c4 0c             	add    $0xc,%esp
  return dst;
801055af:	8b 45 08             	mov    0x8(%ebp),%eax
}
801055b2:	c9                   	leave  
801055b3:	c3                   	ret    

801055b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801055b4:	55                   	push   %ebp
801055b5:	89 e5                	mov    %esp,%ebp
801055b7:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801055ba:	8b 45 08             	mov    0x8(%ebp),%eax
801055bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801055c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801055c6:	eb 30                	jmp    801055f8 <memcmp+0x44>
    if(*s1 != *s2)
801055c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055cb:	0f b6 10             	movzbl (%eax),%edx
801055ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055d1:	0f b6 00             	movzbl (%eax),%eax
801055d4:	38 c2                	cmp    %al,%dl
801055d6:	74 18                	je     801055f0 <memcmp+0x3c>
      return *s1 - *s2;
801055d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055db:	0f b6 00             	movzbl (%eax),%eax
801055de:	0f b6 d0             	movzbl %al,%edx
801055e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055e4:	0f b6 00             	movzbl (%eax),%eax
801055e7:	0f b6 c0             	movzbl %al,%eax
801055ea:	29 c2                	sub    %eax,%edx
801055ec:	89 d0                	mov    %edx,%eax
801055ee:	eb 1a                	jmp    8010560a <memcmp+0x56>
    s1++, s2++;
801055f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055f4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801055f8:	8b 45 10             	mov    0x10(%ebp),%eax
801055fb:	8d 50 ff             	lea    -0x1(%eax),%edx
801055fe:	89 55 10             	mov    %edx,0x10(%ebp)
80105601:	85 c0                	test   %eax,%eax
80105603:	75 c3                	jne    801055c8 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105605:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010560a:	c9                   	leave  
8010560b:	c3                   	ret    

8010560c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010560c:	55                   	push   %ebp
8010560d:	89 e5                	mov    %esp,%ebp
8010560f:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105612:	8b 45 0c             	mov    0xc(%ebp),%eax
80105615:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105618:	8b 45 08             	mov    0x8(%ebp),%eax
8010561b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010561e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105621:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105624:	73 54                	jae    8010567a <memmove+0x6e>
80105626:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105629:	8b 45 10             	mov    0x10(%ebp),%eax
8010562c:	01 d0                	add    %edx,%eax
8010562e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105631:	76 47                	jbe    8010567a <memmove+0x6e>
    s += n;
80105633:	8b 45 10             	mov    0x10(%ebp),%eax
80105636:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105639:	8b 45 10             	mov    0x10(%ebp),%eax
8010563c:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010563f:	eb 13                	jmp    80105654 <memmove+0x48>
      *--d = *--s;
80105641:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105645:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105649:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010564c:	0f b6 10             	movzbl (%eax),%edx
8010564f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105652:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105654:	8b 45 10             	mov    0x10(%ebp),%eax
80105657:	8d 50 ff             	lea    -0x1(%eax),%edx
8010565a:	89 55 10             	mov    %edx,0x10(%ebp)
8010565d:	85 c0                	test   %eax,%eax
8010565f:	75 e0                	jne    80105641 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105661:	eb 24                	jmp    80105687 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105663:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105666:	8d 50 01             	lea    0x1(%eax),%edx
80105669:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010566c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010566f:	8d 4a 01             	lea    0x1(%edx),%ecx
80105672:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105675:	0f b6 12             	movzbl (%edx),%edx
80105678:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010567a:	8b 45 10             	mov    0x10(%ebp),%eax
8010567d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105680:	89 55 10             	mov    %edx,0x10(%ebp)
80105683:	85 c0                	test   %eax,%eax
80105685:	75 dc                	jne    80105663 <memmove+0x57>
      *d++ = *s++;

  return dst;
80105687:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010568a:	c9                   	leave  
8010568b:	c3                   	ret    

8010568c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010568c:	55                   	push   %ebp
8010568d:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010568f:	ff 75 10             	pushl  0x10(%ebp)
80105692:	ff 75 0c             	pushl  0xc(%ebp)
80105695:	ff 75 08             	pushl  0x8(%ebp)
80105698:	e8 6f ff ff ff       	call   8010560c <memmove>
8010569d:	83 c4 0c             	add    $0xc,%esp
}
801056a0:	c9                   	leave  
801056a1:	c3                   	ret    

801056a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801056a2:	55                   	push   %ebp
801056a3:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801056a5:	eb 0c                	jmp    801056b3 <strncmp+0x11>
    n--, p++, q++;
801056a7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801056af:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801056b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056b7:	74 1a                	je     801056d3 <strncmp+0x31>
801056b9:	8b 45 08             	mov    0x8(%ebp),%eax
801056bc:	0f b6 00             	movzbl (%eax),%eax
801056bf:	84 c0                	test   %al,%al
801056c1:	74 10                	je     801056d3 <strncmp+0x31>
801056c3:	8b 45 08             	mov    0x8(%ebp),%eax
801056c6:	0f b6 10             	movzbl (%eax),%edx
801056c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801056cc:	0f b6 00             	movzbl (%eax),%eax
801056cf:	38 c2                	cmp    %al,%dl
801056d1:	74 d4                	je     801056a7 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801056d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056d7:	75 07                	jne    801056e0 <strncmp+0x3e>
    return 0;
801056d9:	b8 00 00 00 00       	mov    $0x0,%eax
801056de:	eb 16                	jmp    801056f6 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801056e0:	8b 45 08             	mov    0x8(%ebp),%eax
801056e3:	0f b6 00             	movzbl (%eax),%eax
801056e6:	0f b6 d0             	movzbl %al,%edx
801056e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ec:	0f b6 00             	movzbl (%eax),%eax
801056ef:	0f b6 c0             	movzbl %al,%eax
801056f2:	29 c2                	sub    %eax,%edx
801056f4:	89 d0                	mov    %edx,%eax
}
801056f6:	5d                   	pop    %ebp
801056f7:	c3                   	ret    

801056f8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801056f8:	55                   	push   %ebp
801056f9:	89 e5                	mov    %esp,%ebp
801056fb:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801056fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105701:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105704:	90                   	nop
80105705:	8b 45 10             	mov    0x10(%ebp),%eax
80105708:	8d 50 ff             	lea    -0x1(%eax),%edx
8010570b:	89 55 10             	mov    %edx,0x10(%ebp)
8010570e:	85 c0                	test   %eax,%eax
80105710:	7e 2c                	jle    8010573e <strncpy+0x46>
80105712:	8b 45 08             	mov    0x8(%ebp),%eax
80105715:	8d 50 01             	lea    0x1(%eax),%edx
80105718:	89 55 08             	mov    %edx,0x8(%ebp)
8010571b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010571e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105721:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105724:	0f b6 12             	movzbl (%edx),%edx
80105727:	88 10                	mov    %dl,(%eax)
80105729:	0f b6 00             	movzbl (%eax),%eax
8010572c:	84 c0                	test   %al,%al
8010572e:	75 d5                	jne    80105705 <strncpy+0xd>
    ;
  while(n-- > 0)
80105730:	eb 0c                	jmp    8010573e <strncpy+0x46>
    *s++ = 0;
80105732:	8b 45 08             	mov    0x8(%ebp),%eax
80105735:	8d 50 01             	lea    0x1(%eax),%edx
80105738:	89 55 08             	mov    %edx,0x8(%ebp)
8010573b:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010573e:	8b 45 10             	mov    0x10(%ebp),%eax
80105741:	8d 50 ff             	lea    -0x1(%eax),%edx
80105744:	89 55 10             	mov    %edx,0x10(%ebp)
80105747:	85 c0                	test   %eax,%eax
80105749:	7f e7                	jg     80105732 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010574b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010574e:	c9                   	leave  
8010574f:	c3                   	ret    

80105750 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105756:	8b 45 08             	mov    0x8(%ebp),%eax
80105759:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010575c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105760:	7f 05                	jg     80105767 <safestrcpy+0x17>
    return os;
80105762:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105765:	eb 31                	jmp    80105798 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105767:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010576b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010576f:	7e 1e                	jle    8010578f <safestrcpy+0x3f>
80105771:	8b 45 08             	mov    0x8(%ebp),%eax
80105774:	8d 50 01             	lea    0x1(%eax),%edx
80105777:	89 55 08             	mov    %edx,0x8(%ebp)
8010577a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010577d:	8d 4a 01             	lea    0x1(%edx),%ecx
80105780:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105783:	0f b6 12             	movzbl (%edx),%edx
80105786:	88 10                	mov    %dl,(%eax)
80105788:	0f b6 00             	movzbl (%eax),%eax
8010578b:	84 c0                	test   %al,%al
8010578d:	75 d8                	jne    80105767 <safestrcpy+0x17>
    ;
  *s = 0;
8010578f:	8b 45 08             	mov    0x8(%ebp),%eax
80105792:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105795:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105798:	c9                   	leave  
80105799:	c3                   	ret    

8010579a <strlen>:

int
strlen(const char *s)
{
8010579a:	55                   	push   %ebp
8010579b:	89 e5                	mov    %esp,%ebp
8010579d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801057a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801057a7:	eb 04                	jmp    801057ad <strlen+0x13>
801057a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057b0:	8b 45 08             	mov    0x8(%ebp),%eax
801057b3:	01 d0                	add    %edx,%eax
801057b5:	0f b6 00             	movzbl (%eax),%eax
801057b8:	84 c0                	test   %al,%al
801057ba:	75 ed                	jne    801057a9 <strlen+0xf>
    ;
  return n;
801057bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057bf:	c9                   	leave  
801057c0:	c3                   	ret    

801057c1 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801057c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801057c5:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801057c9:	55                   	push   %ebp
  pushl %ebx
801057ca:	53                   	push   %ebx
  pushl %esi
801057cb:	56                   	push   %esi
  pushl %edi
801057cc:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801057cd:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801057cf:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801057d1:	5f                   	pop    %edi
  popl %esi
801057d2:	5e                   	pop    %esi
  popl %ebx
801057d3:	5b                   	pop    %ebx
  popl %ebp
801057d4:	5d                   	pop    %ebp
  ret
801057d5:	c3                   	ret    

801057d6 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801057d6:	55                   	push   %ebp
801057d7:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801057d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057df:	8b 00                	mov    (%eax),%eax
801057e1:	3b 45 08             	cmp    0x8(%ebp),%eax
801057e4:	76 12                	jbe    801057f8 <fetchint+0x22>
801057e6:	8b 45 08             	mov    0x8(%ebp),%eax
801057e9:	8d 50 04             	lea    0x4(%eax),%edx
801057ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057f2:	8b 00                	mov    (%eax),%eax
801057f4:	39 c2                	cmp    %eax,%edx
801057f6:	76 07                	jbe    801057ff <fetchint+0x29>
    return -1;
801057f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fd:	eb 0f                	jmp    8010580e <fetchint+0x38>
  *ip = *(int*)(addr);
801057ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105802:	8b 10                	mov    (%eax),%edx
80105804:	8b 45 0c             	mov    0xc(%ebp),%eax
80105807:	89 10                	mov    %edx,(%eax)
  return 0;
80105809:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010580e:	5d                   	pop    %ebp
8010580f:	c3                   	ret    

80105810 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105816:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010581c:	8b 00                	mov    (%eax),%eax
8010581e:	3b 45 08             	cmp    0x8(%ebp),%eax
80105821:	77 07                	ja     8010582a <fetchstr+0x1a>
    return -1;
80105823:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105828:	eb 46                	jmp    80105870 <fetchstr+0x60>
  *pp = (char*)addr;
8010582a:	8b 55 08             	mov    0x8(%ebp),%edx
8010582d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105830:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105832:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105838:	8b 00                	mov    (%eax),%eax
8010583a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010583d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105840:	8b 00                	mov    (%eax),%eax
80105842:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105845:	eb 1c                	jmp    80105863 <fetchstr+0x53>
    if(*s == 0)
80105847:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010584a:	0f b6 00             	movzbl (%eax),%eax
8010584d:	84 c0                	test   %al,%al
8010584f:	75 0e                	jne    8010585f <fetchstr+0x4f>
      return s - *pp;
80105851:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105854:	8b 45 0c             	mov    0xc(%ebp),%eax
80105857:	8b 00                	mov    (%eax),%eax
80105859:	29 c2                	sub    %eax,%edx
8010585b:	89 d0                	mov    %edx,%eax
8010585d:	eb 11                	jmp    80105870 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010585f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105863:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105866:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105869:	72 dc                	jb     80105847 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010586b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105870:	c9                   	leave  
80105871:	c3                   	ret    

80105872 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105872:	55                   	push   %ebp
80105873:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105875:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010587b:	8b 40 18             	mov    0x18(%eax),%eax
8010587e:	8b 40 44             	mov    0x44(%eax),%eax
80105881:	8b 55 08             	mov    0x8(%ebp),%edx
80105884:	c1 e2 02             	shl    $0x2,%edx
80105887:	01 d0                	add    %edx,%eax
80105889:	83 c0 04             	add    $0x4,%eax
8010588c:	ff 75 0c             	pushl  0xc(%ebp)
8010588f:	50                   	push   %eax
80105890:	e8 41 ff ff ff       	call   801057d6 <fetchint>
80105895:	83 c4 08             	add    $0x8,%esp
}
80105898:	c9                   	leave  
80105899:	c3                   	ret    

8010589a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010589a:	55                   	push   %ebp
8010589b:	89 e5                	mov    %esp,%ebp
8010589d:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801058a0:	8d 45 fc             	lea    -0x4(%ebp),%eax
801058a3:	50                   	push   %eax
801058a4:	ff 75 08             	pushl  0x8(%ebp)
801058a7:	e8 c6 ff ff ff       	call   80105872 <argint>
801058ac:	83 c4 08             	add    $0x8,%esp
801058af:	85 c0                	test   %eax,%eax
801058b1:	79 07                	jns    801058ba <argptr+0x20>
    return -1;
801058b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b8:	eb 3b                	jmp    801058f5 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801058ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c0:	8b 00                	mov    (%eax),%eax
801058c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058c5:	39 d0                	cmp    %edx,%eax
801058c7:	76 16                	jbe    801058df <argptr+0x45>
801058c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058cc:	89 c2                	mov    %eax,%edx
801058ce:	8b 45 10             	mov    0x10(%ebp),%eax
801058d1:	01 c2                	add    %eax,%edx
801058d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d9:	8b 00                	mov    (%eax),%eax
801058db:	39 c2                	cmp    %eax,%edx
801058dd:	76 07                	jbe    801058e6 <argptr+0x4c>
    return -1;
801058df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e4:	eb 0f                	jmp    801058f5 <argptr+0x5b>
  *pp = (char*)i;
801058e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e9:	89 c2                	mov    %eax,%edx
801058eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ee:	89 10                	mov    %edx,(%eax)
  return 0;
801058f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    

801058f7 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801058f7:	55                   	push   %ebp
801058f8:	89 e5                	mov    %esp,%ebp
801058fa:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801058fd:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105900:	50                   	push   %eax
80105901:	ff 75 08             	pushl  0x8(%ebp)
80105904:	e8 69 ff ff ff       	call   80105872 <argint>
80105909:	83 c4 08             	add    $0x8,%esp
8010590c:	85 c0                	test   %eax,%eax
8010590e:	79 07                	jns    80105917 <argstr+0x20>
    return -1;
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105915:	eb 0f                	jmp    80105926 <argstr+0x2f>
  return fetchstr(addr, pp);
80105917:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010591a:	ff 75 0c             	pushl  0xc(%ebp)
8010591d:	50                   	push   %eax
8010591e:	e8 ed fe ff ff       	call   80105810 <fetchstr>
80105923:	83 c4 08             	add    $0x8,%esp
}
80105926:	c9                   	leave  
80105927:	c3                   	ret    

80105928 <syscall>:
[SYS_setuid]  sys_setuid,
};

void
syscall(void)
{
80105928:	55                   	push   %ebp
80105929:	89 e5                	mov    %esp,%ebp
8010592b:	53                   	push   %ebx
8010592c:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
8010592f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105935:	8b 40 18             	mov    0x18(%eax),%eax
80105938:	8b 40 1c             	mov    0x1c(%eax),%eax
8010593b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010593e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105942:	7e 30                	jle    80105974 <syscall+0x4c>
80105944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105947:	83 f8 19             	cmp    $0x19,%eax
8010594a:	77 28                	ja     80105974 <syscall+0x4c>
8010594c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010594f:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105956:	85 c0                	test   %eax,%eax
80105958:	74 1a                	je     80105974 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010595a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105960:	8b 58 18             	mov    0x18(%eax),%ebx
80105963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105966:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010596d:	ff d0                	call   *%eax
8010596f:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105972:	eb 34                	jmp    801059a8 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105974:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010597a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010597d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105983:	8b 40 10             	mov    0x10(%eax),%eax
80105986:	ff 75 f4             	pushl  -0xc(%ebp)
80105989:	52                   	push   %edx
8010598a:	50                   	push   %eax
8010598b:	68 df 91 10 80       	push   $0x801091df
80105990:	e8 31 aa ff ff       	call   801003c6 <cprintf>
80105995:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105998:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010599e:	8b 40 18             	mov    0x18(%eax),%eax
801059a1:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801059a8:	90                   	nop
801059a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059ac:	c9                   	leave  
801059ad:	c3                   	ret    

801059ae <sys_up>:
/////////
static struct spinlock sem[5];
static int semaphore[5] = {1, 1, 1, 1, 1};
static int procs[5] = {-1, -1, -1, -1, -1};

int sys_up(void) {
801059ae:	55                   	push   %ebp
801059af:	89 e5                	mov    %esp,%ebp
801059b1:	83 ec 18             	sub    $0x18,%esp
  int n;
  argint(0, &n);
801059b4:	83 ec 08             	sub    $0x8,%esp
801059b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ba:	50                   	push   %eax
801059bb:	6a 00                	push   $0x0
801059bd:	e8 b0 fe ff ff       	call   80105872 <argint>
801059c2:	83 c4 10             	add    $0x10,%esp
  acquire(&sem[n]);
801059c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c8:	6b c0 34             	imul   $0x34,%eax,%eax
801059cb:	05 a0 c6 10 80       	add    $0x8010c6a0,%eax
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	50                   	push   %eax
801059d4:	e8 11 f9 ff ff       	call   801052ea <acquire>
801059d9:	83 c4 10             	add    $0x10,%esp
  if (semaphore[n] == 0) {
801059dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059df:	8b 04 85 a8 c0 10 80 	mov    -0x7fef3f58(,%eax,4),%eax
801059e6:	85 c0                	test   %eax,%eax
801059e8:	75 78                	jne    80105a62 <sys_up+0xb4>
    if (procs[n] == proc->pid) {
801059ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ed:	8b 14 85 bc c0 10 80 	mov    -0x7fef3f44(,%eax,4),%edx
801059f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059fa:	8b 40 10             	mov    0x10(%eax),%eax
801059fd:	39 c2                	cmp    %eax,%edx
801059ff:	75 3b                	jne    80105a3c <sys_up+0x8e>
      ++semaphore[n];
80105a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a04:	8b 14 85 a8 c0 10 80 	mov    -0x7fef3f58(,%eax,4),%edx
80105a0b:	83 c2 01             	add    $0x1,%edx
80105a0e:	89 14 85 a8 c0 10 80 	mov    %edx,-0x7fef3f58(,%eax,4)
      procs[n] = -1;
80105a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a18:	c7 04 85 bc c0 10 80 	movl   $0xffffffff,-0x7fef3f44(,%eax,4)
80105a1f:	ff ff ff ff 
      wakeup(&sem[n]);
80105a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a26:	6b c0 34             	imul   $0x34,%eax,%eax
80105a29:	05 a0 c6 10 80       	add    $0x8010c6a0,%eax
80105a2e:	83 ec 0c             	sub    $0xc,%esp
80105a31:	50                   	push   %eax
80105a32:	e8 9f f6 ff ff       	call   801050d6 <wakeup>
80105a37:	83 c4 10             	add    $0x10,%esp
80105a3a:	eb 61                	jmp    80105a9d <sys_up+0xef>
    } else {
      sleep(&sem[n], &sem[n]);
80105a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3f:	6b c0 34             	imul   $0x34,%eax,%eax
80105a42:	8d 90 a0 c6 10 80    	lea    -0x7fef3960(%eax),%edx
80105a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4b:	6b c0 34             	imul   $0x34,%eax,%eax
80105a4e:	05 a0 c6 10 80       	add    $0x8010c6a0,%eax
80105a53:	83 ec 08             	sub    $0x8,%esp
80105a56:	52                   	push   %edx
80105a57:	50                   	push   %eax
80105a58:	e8 8b f5 ff ff       	call   80104fe8 <sleep>
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	eb 3b                	jmp    80105a9d <sys_up+0xef>
    }
  } else {
    if (procs[n] != proc->pid) {
80105a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a65:	8b 14 85 bc c0 10 80 	mov    -0x7fef3f44(,%eax,4),%edx
80105a6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a72:	8b 40 10             	mov    0x10(%eax),%eax
80105a75:	39 c2                	cmp    %eax,%edx
80105a77:	74 24                	je     80105a9d <sys_up+0xef>
      sleep(&sem[n], &sem[n]);
80105a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7c:	6b c0 34             	imul   $0x34,%eax,%eax
80105a7f:	8d 90 a0 c6 10 80    	lea    -0x7fef3960(%eax),%edx
80105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a88:	6b c0 34             	imul   $0x34,%eax,%eax
80105a8b:	05 a0 c6 10 80       	add    $0x8010c6a0,%eax
80105a90:	83 ec 08             	sub    $0x8,%esp
80105a93:	52                   	push   %edx
80105a94:	50                   	push   %eax
80105a95:	e8 4e f5 ff ff       	call   80104fe8 <sleep>
80105a9a:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&sem[n]);
80105a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa0:	6b c0 34             	imul   $0x34,%eax,%eax
80105aa3:	05 a0 c6 10 80       	add    $0x8010c6a0,%eax
80105aa8:	83 ec 0c             	sub    $0xc,%esp
80105aab:	50                   	push   %eax
80105aac:	e8 a0 f8 ff ff       	call   80105351 <release>
80105ab1:	83 c4 10             	add    $0x10,%esp
  return 0;
80105ab4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ab9:	c9                   	leave  
80105aba:	c3                   	ret    

80105abb <sys_down>:
 
int sys_down(void) {
80105abb:	55                   	push   %ebp
80105abc:	89 e5                	mov    %esp,%ebp
80105abe:	83 ec 18             	sub    $0x18,%esp
  int n;
  argint(0, &n);
80105ac1:	83 ec 08             	sub    $0x8,%esp
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac7:	50                   	push   %eax
80105ac8:	6a 00                	push   $0x0
80105aca:	e8 a3 fd ff ff       	call   80105872 <argint>
80105acf:	83 c4 10             	add    $0x10,%esp
  acquire(&sem[n]);
80105ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad5:	6b c0 34             	imul   $0x34,%eax,%eax
80105ad8:	05 a0 c6 10 80       	add    $0x8010c6a0,%eax
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	50                   	push   %eax
80105ae1:	e8 04 f8 ff ff       	call   801052ea <acquire>
80105ae6:	83 c4 10             	add    $0x10,%esp
  while(42) {
    if (semaphore[n] == 1) {
80105ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aec:	8b 04 85 a8 c0 10 80 	mov    -0x7fef3f58(,%eax,4),%eax
80105af3:	83 f8 01             	cmp    $0x1,%eax
80105af6:	75 2a                	jne    80105b22 <sys_down+0x67>
      --semaphore[n];
80105af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afb:	8b 14 85 a8 c0 10 80 	mov    -0x7fef3f58(,%eax,4),%edx
80105b02:	83 ea 01             	sub    $0x1,%edx
80105b05:	89 14 85 a8 c0 10 80 	mov    %edx,-0x7fef3f58(,%eax,4)
      procs[n] = proc->pid;
80105b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105b16:	8b 52 10             	mov    0x10(%edx),%edx
80105b19:	89 14 85 bc c0 10 80 	mov    %edx,-0x7fef3f44(,%eax,4)
      break;
80105b20:	eb 3e                	jmp    80105b60 <sys_down+0xa5>
    } else {
      if (procs[n] != proc->pid) {
80105b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b25:	8b 14 85 bc c0 10 80 	mov    -0x7fef3f44(,%eax,4),%edx
80105b2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b32:	8b 40 10             	mov    0x10(%eax),%eax
80105b35:	39 c2                	cmp    %eax,%edx
80105b37:	74 26                	je     80105b5f <sys_down+0xa4>
        sleep(&sem[n], &sem[n]);
80105b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3c:	6b c0 34             	imul   $0x34,%eax,%eax
80105b3f:	8d 90 a0 c6 10 80    	lea    -0x7fef3960(%eax),%edx
80105b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b48:	6b c0 34             	imul   $0x34,%eax,%eax
80105b4b:	05 a0 c6 10 80       	add    $0x8010c6a0,%eax
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	52                   	push   %edx
80105b54:	50                   	push   %eax
80105b55:	e8 8e f4 ff ff       	call   80104fe8 <sleep>
80105b5a:	83 c4 10             	add    $0x10,%esp
        continue;
      }
      break;
    }
    break;
  }
80105b5d:	eb 8a                	jmp    80105ae9 <sys_down+0x2e>
    } else {
      if (procs[n] != proc->pid) {
        sleep(&sem[n], &sem[n]);
        continue;
      }
      break;
80105b5f:	90                   	nop
    }
    break;
  }
  release(&sem[n]);
80105b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b63:	6b c0 34             	imul   $0x34,%eax,%eax
80105b66:	05 a0 c6 10 80       	add    $0x8010c6a0,%eax
80105b6b:	83 ec 0c             	sub    $0xc,%esp
80105b6e:	50                   	push   %eax
80105b6f:	e8 dd f7 ff ff       	call   80105351 <release>
80105b74:	83 c4 10             	add    $0x10,%esp
  return 0;
80105b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b7c:	c9                   	leave  
80105b7d:	c3                   	ret    

80105b7e <sys_setuid>:
//////////////////////

int sys_setuid(void) {
80105b7e:	55                   	push   %ebp
80105b7f:	89 e5                	mov    %esp,%ebp
80105b81:	83 ec 18             	sub    $0x18,%esp
  int n;
  argint(0, &n);
80105b84:	83 ec 08             	sub    $0x8,%esp
80105b87:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b8a:	50                   	push   %eax
80105b8b:	6a 00                	push   $0x0
80105b8d:	e8 e0 fc ff ff       	call   80105872 <argint>
80105b92:	83 c4 10             	add    $0x10,%esp
  if(n < 0)
80105b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b98:	85 c0                	test   %eax,%eax
80105b9a:	79 07                	jns    80105ba3 <sys_setuid+0x25>
    return -1;
80105b9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba1:	eb 20                	jmp    80105bc3 <sys_setuid+0x45>
  proc->uid = n;
80105ba3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bac:	89 50 7c             	mov    %edx,0x7c(%eax)
  proc->euid = n;
80105baf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bb8:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80105bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bc3:	c9                   	leave  
80105bc4:	c3                   	ret    

80105bc5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105bc5:	55                   	push   %ebp
80105bc6:	89 e5                	mov    %esp,%ebp
80105bc8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105bcb:	83 ec 08             	sub    $0x8,%esp
80105bce:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bd1:	50                   	push   %eax
80105bd2:	ff 75 08             	pushl  0x8(%ebp)
80105bd5:	e8 98 fc ff ff       	call   80105872 <argint>
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	85 c0                	test   %eax,%eax
80105bdf:	79 07                	jns    80105be8 <argfd+0x23>
    return -1;
80105be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be6:	eb 50                	jmp    80105c38 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105beb:	85 c0                	test   %eax,%eax
80105bed:	78 21                	js     80105c10 <argfd+0x4b>
80105bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bf2:	83 f8 0f             	cmp    $0xf,%eax
80105bf5:	7f 19                	jg     80105c10 <argfd+0x4b>
80105bf7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c00:	83 c2 08             	add    $0x8,%edx
80105c03:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c0e:	75 07                	jne    80105c17 <argfd+0x52>
    return -1;
80105c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c15:	eb 21                	jmp    80105c38 <argfd+0x73>
  if(pfd)
80105c17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105c1b:	74 08                	je     80105c25 <argfd+0x60>
    *pfd = fd;
80105c1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c20:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c23:	89 10                	mov    %edx,(%eax)
  if(pf)
80105c25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c29:	74 08                	je     80105c33 <argfd+0x6e>
    *pf = f;
80105c2b:	8b 45 10             	mov    0x10(%ebp),%eax
80105c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c31:	89 10                	mov    %edx,(%eax)
  return 0;
80105c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c38:	c9                   	leave  
80105c39:	c3                   	ret    

80105c3a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105c3a:	55                   	push   %ebp
80105c3b:	89 e5                	mov    %esp,%ebp
80105c3d:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105c47:	eb 30                	jmp    80105c79 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105c49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c52:	83 c2 08             	add    $0x8,%edx
80105c55:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c59:	85 c0                	test   %eax,%eax
80105c5b:	75 18                	jne    80105c75 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105c5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c63:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c66:	8d 4a 08             	lea    0x8(%edx),%ecx
80105c69:	8b 55 08             	mov    0x8(%ebp),%edx
80105c6c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c73:	eb 0f                	jmp    80105c84 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c75:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105c79:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105c7d:	7e ca                	jle    80105c49 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105c7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c84:	c9                   	leave  
80105c85:	c3                   	ret    

80105c86 <sys_dup>:

int
sys_dup(void)
{
80105c86:	55                   	push   %ebp
80105c87:	89 e5                	mov    %esp,%ebp
80105c89:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105c8c:	83 ec 04             	sub    $0x4,%esp
80105c8f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c92:	50                   	push   %eax
80105c93:	6a 00                	push   $0x0
80105c95:	6a 00                	push   $0x0
80105c97:	e8 29 ff ff ff       	call   80105bc5 <argfd>
80105c9c:	83 c4 10             	add    $0x10,%esp
80105c9f:	85 c0                	test   %eax,%eax
80105ca1:	79 07                	jns    80105caa <sys_dup+0x24>
    return -1;
80105ca3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca8:	eb 31                	jmp    80105cdb <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cad:	83 ec 0c             	sub    $0xc,%esp
80105cb0:	50                   	push   %eax
80105cb1:	e8 84 ff ff ff       	call   80105c3a <fdalloc>
80105cb6:	83 c4 10             	add    $0x10,%esp
80105cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cc0:	79 07                	jns    80105cc9 <sys_dup+0x43>
    return -1;
80105cc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc7:	eb 12                	jmp    80105cdb <sys_dup+0x55>
  filedup(f);
80105cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccc:	83 ec 0c             	sub    $0xc,%esp
80105ccf:	50                   	push   %eax
80105cd0:	e8 c6 b4 ff ff       	call   8010119b <filedup>
80105cd5:	83 c4 10             	add    $0x10,%esp
  return fd;
80105cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105cdb:	c9                   	leave  
80105cdc:	c3                   	ret    

80105cdd <sys_read>:

int
sys_read(void)
{
80105cdd:	55                   	push   %ebp
80105cde:	89 e5                	mov    %esp,%ebp
80105ce0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ce3:	83 ec 04             	sub    $0x4,%esp
80105ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce9:	50                   	push   %eax
80105cea:	6a 00                	push   $0x0
80105cec:	6a 00                	push   $0x0
80105cee:	e8 d2 fe ff ff       	call   80105bc5 <argfd>
80105cf3:	83 c4 10             	add    $0x10,%esp
80105cf6:	85 c0                	test   %eax,%eax
80105cf8:	78 2e                	js     80105d28 <sys_read+0x4b>
80105cfa:	83 ec 08             	sub    $0x8,%esp
80105cfd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d00:	50                   	push   %eax
80105d01:	6a 02                	push   $0x2
80105d03:	e8 6a fb ff ff       	call   80105872 <argint>
80105d08:	83 c4 10             	add    $0x10,%esp
80105d0b:	85 c0                	test   %eax,%eax
80105d0d:	78 19                	js     80105d28 <sys_read+0x4b>
80105d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d12:	83 ec 04             	sub    $0x4,%esp
80105d15:	50                   	push   %eax
80105d16:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d19:	50                   	push   %eax
80105d1a:	6a 01                	push   $0x1
80105d1c:	e8 79 fb ff ff       	call   8010589a <argptr>
80105d21:	83 c4 10             	add    $0x10,%esp
80105d24:	85 c0                	test   %eax,%eax
80105d26:	79 07                	jns    80105d2f <sys_read+0x52>
    return -1;
80105d28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2d:	eb 17                	jmp    80105d46 <sys_read+0x69>
  return fileread(f, p, n);
80105d2f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105d32:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d38:	83 ec 04             	sub    $0x4,%esp
80105d3b:	51                   	push   %ecx
80105d3c:	52                   	push   %edx
80105d3d:	50                   	push   %eax
80105d3e:	e8 0f b7 ff ff       	call   80101452 <fileread>
80105d43:	83 c4 10             	add    $0x10,%esp
}
80105d46:	c9                   	leave  
80105d47:	c3                   	ret    

80105d48 <sys_write>:

int
sys_write(void)
{
80105d48:	55                   	push   %ebp
80105d49:	89 e5                	mov    %esp,%ebp
80105d4b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d4e:	83 ec 04             	sub    $0x4,%esp
80105d51:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d54:	50                   	push   %eax
80105d55:	6a 00                	push   $0x0
80105d57:	6a 00                	push   $0x0
80105d59:	e8 67 fe ff ff       	call   80105bc5 <argfd>
80105d5e:	83 c4 10             	add    $0x10,%esp
80105d61:	85 c0                	test   %eax,%eax
80105d63:	78 2e                	js     80105d93 <sys_write+0x4b>
80105d65:	83 ec 08             	sub    $0x8,%esp
80105d68:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d6b:	50                   	push   %eax
80105d6c:	6a 02                	push   $0x2
80105d6e:	e8 ff fa ff ff       	call   80105872 <argint>
80105d73:	83 c4 10             	add    $0x10,%esp
80105d76:	85 c0                	test   %eax,%eax
80105d78:	78 19                	js     80105d93 <sys_write+0x4b>
80105d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d7d:	83 ec 04             	sub    $0x4,%esp
80105d80:	50                   	push   %eax
80105d81:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d84:	50                   	push   %eax
80105d85:	6a 01                	push   $0x1
80105d87:	e8 0e fb ff ff       	call   8010589a <argptr>
80105d8c:	83 c4 10             	add    $0x10,%esp
80105d8f:	85 c0                	test   %eax,%eax
80105d91:	79 07                	jns    80105d9a <sys_write+0x52>
    return -1;
80105d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d98:	eb 17                	jmp    80105db1 <sys_write+0x69>
  return filewrite(f, p, n);
80105d9a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105d9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da3:	83 ec 04             	sub    $0x4,%esp
80105da6:	51                   	push   %ecx
80105da7:	52                   	push   %edx
80105da8:	50                   	push   %eax
80105da9:	e8 66 b7 ff ff       	call   80101514 <filewrite>
80105dae:	83 c4 10             	add    $0x10,%esp
}
80105db1:	c9                   	leave  
80105db2:	c3                   	ret    

80105db3 <sys_close>:

int
sys_close(void)
{
80105db3:	55                   	push   %ebp
80105db4:	89 e5                	mov    %esp,%ebp
80105db6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105db9:	83 ec 04             	sub    $0x4,%esp
80105dbc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dbf:	50                   	push   %eax
80105dc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dc3:	50                   	push   %eax
80105dc4:	6a 00                	push   $0x0
80105dc6:	e8 fa fd ff ff       	call   80105bc5 <argfd>
80105dcb:	83 c4 10             	add    $0x10,%esp
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	79 07                	jns    80105dd9 <sys_close+0x26>
    return -1;
80105dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd7:	eb 28                	jmp    80105e01 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105dd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105de2:	83 c2 08             	add    $0x8,%edx
80105de5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105dec:	00 
  fileclose(f);
80105ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df0:	83 ec 0c             	sub    $0xc,%esp
80105df3:	50                   	push   %eax
80105df4:	e8 f3 b3 ff ff       	call   801011ec <fileclose>
80105df9:	83 c4 10             	add    $0x10,%esp
  return 0;
80105dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e01:	c9                   	leave  
80105e02:	c3                   	ret    

80105e03 <sys_fstat>:

int
sys_fstat(void)
{
80105e03:	55                   	push   %ebp
80105e04:	89 e5                	mov    %esp,%ebp
80105e06:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105e09:	83 ec 04             	sub    $0x4,%esp
80105e0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e0f:	50                   	push   %eax
80105e10:	6a 00                	push   $0x0
80105e12:	6a 00                	push   $0x0
80105e14:	e8 ac fd ff ff       	call   80105bc5 <argfd>
80105e19:	83 c4 10             	add    $0x10,%esp
80105e1c:	85 c0                	test   %eax,%eax
80105e1e:	78 17                	js     80105e37 <sys_fstat+0x34>
80105e20:	83 ec 04             	sub    $0x4,%esp
80105e23:	6a 14                	push   $0x14
80105e25:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e28:	50                   	push   %eax
80105e29:	6a 01                	push   $0x1
80105e2b:	e8 6a fa ff ff       	call   8010589a <argptr>
80105e30:	83 c4 10             	add    $0x10,%esp
80105e33:	85 c0                	test   %eax,%eax
80105e35:	79 07                	jns    80105e3e <sys_fstat+0x3b>
    return -1;
80105e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3c:	eb 13                	jmp    80105e51 <sys_fstat+0x4e>
  return filestat(f, st);
80105e3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e44:	83 ec 08             	sub    $0x8,%esp
80105e47:	52                   	push   %edx
80105e48:	50                   	push   %eax
80105e49:	e8 a3 b5 ff ff       	call   801013f1 <filestat>
80105e4e:	83 c4 10             	add    $0x10,%esp
}
80105e51:	c9                   	leave  
80105e52:	c3                   	ret    

80105e53 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105e53:	55                   	push   %ebp
80105e54:	89 e5                	mov    %esp,%ebp
80105e56:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105e59:	83 ec 08             	sub    $0x8,%esp
80105e5c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105e5f:	50                   	push   %eax
80105e60:	6a 00                	push   $0x0
80105e62:	e8 90 fa ff ff       	call   801058f7 <argstr>
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	85 c0                	test   %eax,%eax
80105e6c:	78 15                	js     80105e83 <sys_link+0x30>
80105e6e:	83 ec 08             	sub    $0x8,%esp
80105e71:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105e74:	50                   	push   %eax
80105e75:	6a 01                	push   $0x1
80105e77:	e8 7b fa ff ff       	call   801058f7 <argstr>
80105e7c:	83 c4 10             	add    $0x10,%esp
80105e7f:	85 c0                	test   %eax,%eax
80105e81:	79 0a                	jns    80105e8d <sys_link+0x3a>
    return -1;
80105e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e88:	e9 68 01 00 00       	jmp    80105ff5 <sys_link+0x1a2>

  begin_op();
80105e8d:	e8 91 d9 ff ff       	call   80103823 <begin_op>
  if((ip = namei(old)) == 0){
80105e92:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105e95:	83 ec 0c             	sub    $0xc,%esp
80105e98:	50                   	push   %eax
80105e99:	e8 60 c9 ff ff       	call   801027fe <namei>
80105e9e:	83 c4 10             	add    $0x10,%esp
80105ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ea4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ea8:	75 0f                	jne    80105eb9 <sys_link+0x66>
    end_op();
80105eaa:	e8 00 da ff ff       	call   801038af <end_op>
    return -1;
80105eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb4:	e9 3c 01 00 00       	jmp    80105ff5 <sys_link+0x1a2>
  }

  ilock(ip);
80105eb9:	83 ec 0c             	sub    $0xc,%esp
80105ebc:	ff 75 f4             	pushl  -0xc(%ebp)
80105ebf:	e8 7c bd ff ff       	call   80101c40 <ilock>
80105ec4:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eca:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80105ece:	66 83 f8 01          	cmp    $0x1,%ax
80105ed2:	75 1d                	jne    80105ef1 <sys_link+0x9e>
    iunlockput(ip);
80105ed4:	83 ec 0c             	sub    $0xc,%esp
80105ed7:	ff 75 f4             	pushl  -0xc(%ebp)
80105eda:	e8 21 c0 ff ff       	call   80101f00 <iunlockput>
80105edf:	83 c4 10             	add    $0x10,%esp
    end_op();
80105ee2:	e8 c8 d9 ff ff       	call   801038af <end_op>
    return -1;
80105ee7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eec:	e9 04 01 00 00       	jmp    80105ff5 <sys_link+0x1a2>
  }

  ip->nlink++;
80105ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef4:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
80105ef8:	83 c0 01             	add    $0x1,%eax
80105efb:	89 c2                	mov    %eax,%edx
80105efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f00:	66 89 50 1e          	mov    %dx,0x1e(%eax)
  iupdate(ip);
80105f04:	83 ec 0c             	sub    $0xc,%esp
80105f07:	ff 75 f4             	pushl  -0xc(%ebp)
80105f0a:	e8 57 bb ff ff       	call   80101a66 <iupdate>
80105f0f:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105f12:	83 ec 0c             	sub    $0xc,%esp
80105f15:	ff 75 f4             	pushl  -0xc(%ebp)
80105f18:	e8 81 be ff ff       	call   80101d9e <iunlock>
80105f1d:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105f20:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f23:	83 ec 08             	sub    $0x8,%esp
80105f26:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105f29:	52                   	push   %edx
80105f2a:	50                   	push   %eax
80105f2b:	e8 ea c8 ff ff       	call   8010281a <nameiparent>
80105f30:	83 c4 10             	add    $0x10,%esp
80105f33:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f3a:	74 71                	je     80105fad <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105f3c:	83 ec 0c             	sub    $0xc,%esp
80105f3f:	ff 75 f0             	pushl  -0x10(%ebp)
80105f42:	e8 f9 bc ff ff       	call   80101c40 <ilock>
80105f47:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f4d:	8b 10                	mov    (%eax),%edx
80105f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f52:	8b 00                	mov    (%eax),%eax
80105f54:	39 c2                	cmp    %eax,%edx
80105f56:	75 1d                	jne    80105f75 <sys_link+0x122>
80105f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f5b:	8b 40 04             	mov    0x4(%eax),%eax
80105f5e:	83 ec 04             	sub    $0x4,%esp
80105f61:	50                   	push   %eax
80105f62:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105f65:	50                   	push   %eax
80105f66:	ff 75 f0             	pushl  -0x10(%ebp)
80105f69:	e8 f4 c5 ff ff       	call   80102562 <dirlink>
80105f6e:	83 c4 10             	add    $0x10,%esp
80105f71:	85 c0                	test   %eax,%eax
80105f73:	79 10                	jns    80105f85 <sys_link+0x132>
    iunlockput(dp);
80105f75:	83 ec 0c             	sub    $0xc,%esp
80105f78:	ff 75 f0             	pushl  -0x10(%ebp)
80105f7b:	e8 80 bf ff ff       	call   80101f00 <iunlockput>
80105f80:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105f83:	eb 29                	jmp    80105fae <sys_link+0x15b>
  }
  iunlockput(dp);
80105f85:	83 ec 0c             	sub    $0xc,%esp
80105f88:	ff 75 f0             	pushl  -0x10(%ebp)
80105f8b:	e8 70 bf ff ff       	call   80101f00 <iunlockput>
80105f90:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105f93:	83 ec 0c             	sub    $0xc,%esp
80105f96:	ff 75 f4             	pushl  -0xc(%ebp)
80105f99:	e8 72 be ff ff       	call   80101e10 <iput>
80105f9e:	83 c4 10             	add    $0x10,%esp

  end_op();
80105fa1:	e8 09 d9 ff ff       	call   801038af <end_op>

  return 0;
80105fa6:	b8 00 00 00 00       	mov    $0x0,%eax
80105fab:	eb 48                	jmp    80105ff5 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105fad:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105fae:	83 ec 0c             	sub    $0xc,%esp
80105fb1:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb4:	e8 87 bc ff ff       	call   80101c40 <ilock>
80105fb9:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fbf:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
80105fc3:	83 e8 01             	sub    $0x1,%eax
80105fc6:	89 c2                	mov    %eax,%edx
80105fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fcb:	66 89 50 1e          	mov    %dx,0x1e(%eax)
  iupdate(ip);
80105fcf:	83 ec 0c             	sub    $0xc,%esp
80105fd2:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd5:	e8 8c ba ff ff       	call   80101a66 <iupdate>
80105fda:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105fdd:	83 ec 0c             	sub    $0xc,%esp
80105fe0:	ff 75 f4             	pushl  -0xc(%ebp)
80105fe3:	e8 18 bf ff ff       	call   80101f00 <iunlockput>
80105fe8:	83 c4 10             	add    $0x10,%esp
  end_op();
80105feb:	e8 bf d8 ff ff       	call   801038af <end_op>
  return -1;
80105ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ff5:	c9                   	leave  
80105ff6:	c3                   	ret    

80105ff7 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105ff7:	55                   	push   %ebp
80105ff8:	89 e5                	mov    %esp,%ebp
80105ffa:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ffd:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106004:	eb 40                	jmp    80106046 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106009:	6a 10                	push   $0x10
8010600b:	50                   	push   %eax
8010600c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010600f:	50                   	push   %eax
80106010:	ff 75 08             	pushl  0x8(%ebp)
80106013:	e8 96 c1 ff ff       	call   801021ae <readi>
80106018:	83 c4 10             	add    $0x10,%esp
8010601b:	83 f8 10             	cmp    $0x10,%eax
8010601e:	74 0d                	je     8010602d <isdirempty+0x36>
      panic("isdirempty: readi");
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	68 fb 91 10 80       	push   $0x801091fb
80106028:	e8 39 a5 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
8010602d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106031:	66 85 c0             	test   %ax,%ax
80106034:	74 07                	je     8010603d <isdirempty+0x46>
      return 0;
80106036:	b8 00 00 00 00       	mov    $0x0,%eax
8010603b:	eb 1b                	jmp    80106058 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010603d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106040:	83 c0 10             	add    $0x10,%eax
80106043:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106046:	8b 45 08             	mov    0x8(%ebp),%eax
80106049:	8b 50 20             	mov    0x20(%eax),%edx
8010604c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010604f:	39 c2                	cmp    %eax,%edx
80106051:	77 b3                	ja     80106006 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106053:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106058:	c9                   	leave  
80106059:	c3                   	ret    

8010605a <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010605a:	55                   	push   %ebp
8010605b:	89 e5                	mov    %esp,%ebp
8010605d:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106060:	83 ec 08             	sub    $0x8,%esp
80106063:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106066:	50                   	push   %eax
80106067:	6a 00                	push   $0x0
80106069:	e8 89 f8 ff ff       	call   801058f7 <argstr>
8010606e:	83 c4 10             	add    $0x10,%esp
80106071:	85 c0                	test   %eax,%eax
80106073:	79 0a                	jns    8010607f <sys_unlink+0x25>
    return -1;
80106075:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607a:	e9 bc 01 00 00       	jmp    8010623b <sys_unlink+0x1e1>

  begin_op();
8010607f:	e8 9f d7 ff ff       	call   80103823 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106084:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106087:	83 ec 08             	sub    $0x8,%esp
8010608a:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010608d:	52                   	push   %edx
8010608e:	50                   	push   %eax
8010608f:	e8 86 c7 ff ff       	call   8010281a <nameiparent>
80106094:	83 c4 10             	add    $0x10,%esp
80106097:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010609a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010609e:	75 0f                	jne    801060af <sys_unlink+0x55>
    end_op();
801060a0:	e8 0a d8 ff ff       	call   801038af <end_op>
    return -1;
801060a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060aa:	e9 8c 01 00 00       	jmp    8010623b <sys_unlink+0x1e1>
  }

  ilock(dp);
801060af:	83 ec 0c             	sub    $0xc,%esp
801060b2:	ff 75 f4             	pushl  -0xc(%ebp)
801060b5:	e8 86 bb ff ff       	call   80101c40 <ilock>
801060ba:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801060bd:	83 ec 08             	sub    $0x8,%esp
801060c0:	68 0d 92 10 80       	push   $0x8010920d
801060c5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801060c8:	50                   	push   %eax
801060c9:	e8 bf c3 ff ff       	call   8010248d <namecmp>
801060ce:	83 c4 10             	add    $0x10,%esp
801060d1:	85 c0                	test   %eax,%eax
801060d3:	0f 84 4a 01 00 00    	je     80106223 <sys_unlink+0x1c9>
801060d9:	83 ec 08             	sub    $0x8,%esp
801060dc:	68 0f 92 10 80       	push   $0x8010920f
801060e1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801060e4:	50                   	push   %eax
801060e5:	e8 a3 c3 ff ff       	call   8010248d <namecmp>
801060ea:	83 c4 10             	add    $0x10,%esp
801060ed:	85 c0                	test   %eax,%eax
801060ef:	0f 84 2e 01 00 00    	je     80106223 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801060f5:	83 ec 04             	sub    $0x4,%esp
801060f8:	8d 45 c8             	lea    -0x38(%ebp),%eax
801060fb:	50                   	push   %eax
801060fc:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801060ff:	50                   	push   %eax
80106100:	ff 75 f4             	pushl  -0xc(%ebp)
80106103:	e8 a0 c3 ff ff       	call   801024a8 <dirlookup>
80106108:	83 c4 10             	add    $0x10,%esp
8010610b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010610e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106112:	0f 84 0a 01 00 00    	je     80106222 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106118:	83 ec 0c             	sub    $0xc,%esp
8010611b:	ff 75 f0             	pushl  -0x10(%ebp)
8010611e:	e8 1d bb ff ff       	call   80101c40 <ilock>
80106123:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106126:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106129:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
8010612d:	66 85 c0             	test   %ax,%ax
80106130:	7f 0d                	jg     8010613f <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106132:	83 ec 0c             	sub    $0xc,%esp
80106135:	68 12 92 10 80       	push   $0x80109212
8010613a:	e8 27 a4 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010613f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106142:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80106146:	66 83 f8 01          	cmp    $0x1,%ax
8010614a:	75 25                	jne    80106171 <sys_unlink+0x117>
8010614c:	83 ec 0c             	sub    $0xc,%esp
8010614f:	ff 75 f0             	pushl  -0x10(%ebp)
80106152:	e8 a0 fe ff ff       	call   80105ff7 <isdirempty>
80106157:	83 c4 10             	add    $0x10,%esp
8010615a:	85 c0                	test   %eax,%eax
8010615c:	75 13                	jne    80106171 <sys_unlink+0x117>
    iunlockput(ip);
8010615e:	83 ec 0c             	sub    $0xc,%esp
80106161:	ff 75 f0             	pushl  -0x10(%ebp)
80106164:	e8 97 bd ff ff       	call   80101f00 <iunlockput>
80106169:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010616c:	e9 b2 00 00 00       	jmp    80106223 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106171:	83 ec 04             	sub    $0x4,%esp
80106174:	6a 10                	push   $0x10
80106176:	6a 00                	push   $0x0
80106178:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010617b:	50                   	push   %eax
8010617c:	e8 cc f3 ff ff       	call   8010554d <memset>
80106181:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106184:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106187:	6a 10                	push   $0x10
80106189:	50                   	push   %eax
8010618a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010618d:	50                   	push   %eax
8010618e:	ff 75 f4             	pushl  -0xc(%ebp)
80106191:	e8 6f c1 ff ff       	call   80102305 <writei>
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	83 f8 10             	cmp    $0x10,%eax
8010619c:	74 0d                	je     801061ab <sys_unlink+0x151>
    panic("unlink: writei");
8010619e:	83 ec 0c             	sub    $0xc,%esp
801061a1:	68 24 92 10 80       	push   $0x80109224
801061a6:	e8 bb a3 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801061ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ae:	0f b7 40 18          	movzwl 0x18(%eax),%eax
801061b2:	66 83 f8 01          	cmp    $0x1,%ax
801061b6:	75 21                	jne    801061d9 <sys_unlink+0x17f>
    dp->nlink--;
801061b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061bb:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
801061bf:	83 e8 01             	sub    $0x1,%eax
801061c2:	89 c2                	mov    %eax,%edx
801061c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c7:	66 89 50 1e          	mov    %dx,0x1e(%eax)
    iupdate(dp);
801061cb:	83 ec 0c             	sub    $0xc,%esp
801061ce:	ff 75 f4             	pushl  -0xc(%ebp)
801061d1:	e8 90 b8 ff ff       	call   80101a66 <iupdate>
801061d6:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801061d9:	83 ec 0c             	sub    $0xc,%esp
801061dc:	ff 75 f4             	pushl  -0xc(%ebp)
801061df:	e8 1c bd ff ff       	call   80101f00 <iunlockput>
801061e4:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801061e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ea:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
801061ee:	83 e8 01             	sub    $0x1,%eax
801061f1:	89 c2                	mov    %eax,%edx
801061f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f6:	66 89 50 1e          	mov    %dx,0x1e(%eax)
  iupdate(ip);
801061fa:	83 ec 0c             	sub    $0xc,%esp
801061fd:	ff 75 f0             	pushl  -0x10(%ebp)
80106200:	e8 61 b8 ff ff       	call   80101a66 <iupdate>
80106205:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106208:	83 ec 0c             	sub    $0xc,%esp
8010620b:	ff 75 f0             	pushl  -0x10(%ebp)
8010620e:	e8 ed bc ff ff       	call   80101f00 <iunlockput>
80106213:	83 c4 10             	add    $0x10,%esp

  end_op();
80106216:	e8 94 d6 ff ff       	call   801038af <end_op>

  return 0;
8010621b:	b8 00 00 00 00       	mov    $0x0,%eax
80106220:	eb 19                	jmp    8010623b <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106222:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106223:	83 ec 0c             	sub    $0xc,%esp
80106226:	ff 75 f4             	pushl  -0xc(%ebp)
80106229:	e8 d2 bc ff ff       	call   80101f00 <iunlockput>
8010622e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106231:	e8 79 d6 ff ff       	call   801038af <end_op>
  return -1;
80106236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010623b:	c9                   	leave  
8010623c:	c3                   	ret    

8010623d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010623d:	55                   	push   %ebp
8010623e:	89 e5                	mov    %esp,%ebp
80106240:	83 ec 38             	sub    $0x38,%esp
80106243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106246:	8b 55 10             	mov    0x10(%ebp),%edx
80106249:	8b 45 14             	mov    0x14(%ebp),%eax
8010624c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106250:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106254:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106258:	83 ec 08             	sub    $0x8,%esp
8010625b:	8d 45 de             	lea    -0x22(%ebp),%eax
8010625e:	50                   	push   %eax
8010625f:	ff 75 08             	pushl  0x8(%ebp)
80106262:	e8 b3 c5 ff ff       	call   8010281a <nameiparent>
80106267:	83 c4 10             	add    $0x10,%esp
8010626a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010626d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106271:	75 0a                	jne    8010627d <create+0x40>
    return 0;
80106273:	b8 00 00 00 00       	mov    $0x0,%eax
80106278:	e9 b1 01 00 00       	jmp    8010642e <create+0x1f1>
  ilock(dp);
8010627d:	83 ec 0c             	sub    $0xc,%esp
80106280:	ff 75 f4             	pushl  -0xc(%ebp)
80106283:	e8 b8 b9 ff ff       	call   80101c40 <ilock>
80106288:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010628b:	83 ec 04             	sub    $0x4,%esp
8010628e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106291:	50                   	push   %eax
80106292:	8d 45 de             	lea    -0x22(%ebp),%eax
80106295:	50                   	push   %eax
80106296:	ff 75 f4             	pushl  -0xc(%ebp)
80106299:	e8 0a c2 ff ff       	call   801024a8 <dirlookup>
8010629e:	83 c4 10             	add    $0x10,%esp
801062a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062a8:	74 5d                	je     80106307 <create+0xca>
    iunlockput(dp);
801062aa:	83 ec 0c             	sub    $0xc,%esp
801062ad:	ff 75 f4             	pushl  -0xc(%ebp)
801062b0:	e8 4b bc ff ff       	call   80101f00 <iunlockput>
801062b5:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801062b8:	83 ec 0c             	sub    $0xc,%esp
801062bb:	ff 75 f0             	pushl  -0x10(%ebp)
801062be:	e8 7d b9 ff ff       	call   80101c40 <ilock>
801062c3:	83 c4 10             	add    $0x10,%esp
    if((type == T_FILE && (ip->type == T_FILE || ip->type == T_FIFO)))
801062c6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801062cb:	75 22                	jne    801062ef <create+0xb2>
801062cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062d0:	0f b7 40 18          	movzwl 0x18(%eax),%eax
801062d4:	66 83 f8 02          	cmp    $0x2,%ax
801062d8:	74 0d                	je     801062e7 <create+0xaa>
801062da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062dd:	0f b7 40 18          	movzwl 0x18(%eax),%eax
801062e1:	66 83 f8 04          	cmp    $0x4,%ax
801062e5:	75 08                	jne    801062ef <create+0xb2>
      return ip;
801062e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ea:	e9 3f 01 00 00       	jmp    8010642e <create+0x1f1>
    iunlockput(ip);
801062ef:	83 ec 0c             	sub    $0xc,%esp
801062f2:	ff 75 f0             	pushl  -0x10(%ebp)
801062f5:	e8 06 bc ff ff       	call   80101f00 <iunlockput>
801062fa:	83 c4 10             	add    $0x10,%esp
    return 0;
801062fd:	b8 00 00 00 00       	mov    $0x0,%eax
80106302:	e9 27 01 00 00       	jmp    8010642e <create+0x1f1>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106307:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010630b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010630e:	8b 00                	mov    (%eax),%eax
80106310:	83 ec 08             	sub    $0x8,%esp
80106313:	52                   	push   %edx
80106314:	50                   	push   %eax
80106315:	e8 75 b6 ff ff       	call   8010198f <ialloc>
8010631a:	83 c4 10             	add    $0x10,%esp
8010631d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106320:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106324:	75 0d                	jne    80106333 <create+0xf6>
    panic("create: ialloc");
80106326:	83 ec 0c             	sub    $0xc,%esp
80106329:	68 33 92 10 80       	push   $0x80109233
8010632e:	e8 33 a2 ff ff       	call   80100566 <panic>

  ilock(ip); // initialize inode by, wf.
80106333:	83 ec 0c             	sub    $0xc,%esp
80106336:	ff 75 f0             	pushl  -0x10(%ebp)
80106339:	e8 02 b9 ff ff       	call   80101c40 <ilock>
8010633e:	83 c4 10             	add    $0x10,%esp
  ip->rf = 0;
80106341:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106344:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  ip->wf = 0;
8010634b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  ip->major = major;
80106355:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106358:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010635c:	66 89 50 1a          	mov    %dx,0x1a(%eax)
  ip->minor = minor;
80106360:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106363:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106367:	66 89 50 1c          	mov    %dx,0x1c(%eax)
  ip->nlink = 1;
8010636b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010636e:	66 c7 40 1e 01 00    	movw   $0x1,0x1e(%eax)
  iupdate(ip);
80106374:	83 ec 0c             	sub    $0xc,%esp
80106377:	ff 75 f0             	pushl  -0x10(%ebp)
8010637a:	e8 e7 b6 ff ff       	call   80101a66 <iupdate>
8010637f:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106382:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106387:	75 6a                	jne    801063f3 <create+0x1b6>
    dp->nlink++;  // for ".."
80106389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638c:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
80106390:	83 c0 01             	add    $0x1,%eax
80106393:	89 c2                	mov    %eax,%edx
80106395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106398:	66 89 50 1e          	mov    %dx,0x1e(%eax)
    iupdate(dp);
8010639c:	83 ec 0c             	sub    $0xc,%esp
8010639f:	ff 75 f4             	pushl  -0xc(%ebp)
801063a2:	e8 bf b6 ff ff       	call   80101a66 <iupdate>
801063a7:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801063aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ad:	8b 40 04             	mov    0x4(%eax),%eax
801063b0:	83 ec 04             	sub    $0x4,%esp
801063b3:	50                   	push   %eax
801063b4:	68 0d 92 10 80       	push   $0x8010920d
801063b9:	ff 75 f0             	pushl  -0x10(%ebp)
801063bc:	e8 a1 c1 ff ff       	call   80102562 <dirlink>
801063c1:	83 c4 10             	add    $0x10,%esp
801063c4:	85 c0                	test   %eax,%eax
801063c6:	78 1e                	js     801063e6 <create+0x1a9>
801063c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063cb:	8b 40 04             	mov    0x4(%eax),%eax
801063ce:	83 ec 04             	sub    $0x4,%esp
801063d1:	50                   	push   %eax
801063d2:	68 0f 92 10 80       	push   $0x8010920f
801063d7:	ff 75 f0             	pushl  -0x10(%ebp)
801063da:	e8 83 c1 ff ff       	call   80102562 <dirlink>
801063df:	83 c4 10             	add    $0x10,%esp
801063e2:	85 c0                	test   %eax,%eax
801063e4:	79 0d                	jns    801063f3 <create+0x1b6>
      panic("create dots");
801063e6:	83 ec 0c             	sub    $0xc,%esp
801063e9:	68 42 92 10 80       	push   $0x80109242
801063ee:	e8 73 a1 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801063f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063f6:	8b 40 04             	mov    0x4(%eax),%eax
801063f9:	83 ec 04             	sub    $0x4,%esp
801063fc:	50                   	push   %eax
801063fd:	8d 45 de             	lea    -0x22(%ebp),%eax
80106400:	50                   	push   %eax
80106401:	ff 75 f4             	pushl  -0xc(%ebp)
80106404:	e8 59 c1 ff ff       	call   80102562 <dirlink>
80106409:	83 c4 10             	add    $0x10,%esp
8010640c:	85 c0                	test   %eax,%eax
8010640e:	79 0d                	jns    8010641d <create+0x1e0>
    panic("create: dirlink");
80106410:	83 ec 0c             	sub    $0xc,%esp
80106413:	68 4e 92 10 80       	push   $0x8010924e
80106418:	e8 49 a1 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010641d:	83 ec 0c             	sub    $0xc,%esp
80106420:	ff 75 f4             	pushl  -0xc(%ebp)
80106423:	e8 d8 ba ff ff       	call   80101f00 <iunlockput>
80106428:	83 c4 10             	add    $0x10,%esp

  return ip;
8010642b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010642e:	c9                   	leave  
8010642f:	c3                   	ret    

80106430 <sys_open>:

int
sys_open(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	83 ec 28             	sub    $0x28,%esp
  int fd, omode;
  struct file *f;
  struct inode *ip;
  struct pipe * p;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106436:	83 ec 08             	sub    $0x8,%esp
80106439:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010643c:	50                   	push   %eax
8010643d:	6a 00                	push   $0x0
8010643f:	e8 b3 f4 ff ff       	call   801058f7 <argstr>
80106444:	83 c4 10             	add    $0x10,%esp
80106447:	85 c0                	test   %eax,%eax
80106449:	78 15                	js     80106460 <sys_open+0x30>
8010644b:	83 ec 08             	sub    $0x8,%esp
8010644e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106451:	50                   	push   %eax
80106452:	6a 01                	push   $0x1
80106454:	e8 19 f4 ff ff       	call   80105872 <argint>
80106459:	83 c4 10             	add    $0x10,%esp
8010645c:	85 c0                	test   %eax,%eax
8010645e:	79 0a                	jns    8010646a <sys_open+0x3a>
    return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106465:	e9 50 04 00 00       	jmp    801068ba <sys_open+0x48a>

  begin_op();
8010646a:	e8 b4 d3 ff ff       	call   80103823 <begin_op>

  if((omode & O_CREATE)){
8010646f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106472:	25 00 02 00 00       	and    $0x200,%eax
80106477:	85 c0                	test   %eax,%eax
80106479:	74 56                	je     801064d1 <sys_open+0xa1>
    if((ip = namei(path)) == 0){   
8010647b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010647e:	83 ec 0c             	sub    $0xc,%esp
80106481:	50                   	push   %eax
80106482:	e8 77 c3 ff ff       	call   801027fe <namei>
80106487:	83 c4 10             	add    $0x10,%esp
8010648a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010648d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106491:	75 2e                	jne    801064c1 <sys_open+0x91>
      ip = create(path, T_FILE, 0, 0);
80106493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106496:	6a 00                	push   $0x0
80106498:	6a 00                	push   $0x0
8010649a:	6a 02                	push   $0x2
8010649c:	50                   	push   %eax
8010649d:	e8 9b fd ff ff       	call   8010623d <create>
801064a2:	83 c4 10             	add    $0x10,%esp
801064a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(ip == 0){
801064a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064ac:	0f 85 8f 00 00 00    	jne    80106541 <sys_open+0x111>
        end_op();
801064b2:	e8 f8 d3 ff ff       	call   801038af <end_op>
        return -1;
801064b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064bc:	e9 f9 03 00 00       	jmp    801068ba <sys_open+0x48a>
      }
    } else {
      ilock(ip);
801064c1:	83 ec 0c             	sub    $0xc,%esp
801064c4:	ff 75 f4             	pushl  -0xc(%ebp)
801064c7:	e8 74 b7 ff ff       	call   80101c40 <ilock>
801064cc:	83 c4 10             	add    $0x10,%esp
801064cf:	eb 70                	jmp    80106541 <sys_open+0x111>
    }
  } else {
    if((ip = namei(path)) == 0){
801064d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064d4:	83 ec 0c             	sub    $0xc,%esp
801064d7:	50                   	push   %eax
801064d8:	e8 21 c3 ff ff       	call   801027fe <namei>
801064dd:	83 c4 10             	add    $0x10,%esp
801064e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064e7:	75 0f                	jne    801064f8 <sys_open+0xc8>
      end_op();
801064e9:	e8 c1 d3 ff ff       	call   801038af <end_op>
      return -1;
801064ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064f3:	e9 c2 03 00 00       	jmp    801068ba <sys_open+0x48a>
    }
    ilock(ip);
801064f8:	83 ec 0c             	sub    $0xc,%esp
801064fb:	ff 75 f4             	pushl  -0xc(%ebp)
801064fe:	e8 3d b7 ff ff       	call   80101c40 <ilock>
80106503:	83 c4 10             	add    $0x10,%esp
    if((ip->type == T_DIR && omode != O_RDONLY) && !(omode & O_NBLOCK)) {
80106506:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106509:	0f b7 40 18          	movzwl 0x18(%eax),%eax
8010650d:	66 83 f8 01          	cmp    $0x1,%ax
80106511:	75 2e                	jne    80106541 <sys_open+0x111>
80106513:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106516:	85 c0                	test   %eax,%eax
80106518:	74 27                	je     80106541 <sys_open+0x111>
8010651a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010651d:	83 e0 10             	and    $0x10,%eax
80106520:	85 c0                	test   %eax,%eax
80106522:	75 1d                	jne    80106541 <sys_open+0x111>
      iunlockput(ip);
80106524:	83 ec 0c             	sub    $0xc,%esp
80106527:	ff 75 f4             	pushl  -0xc(%ebp)
8010652a:	e8 d1 b9 ff ff       	call   80101f00 <iunlockput>
8010652f:	83 c4 10             	add    $0x10,%esp
      end_op();
80106532:	e8 78 d3 ff ff       	call   801038af <end_op>
      return -1;
80106537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010653c:	e9 79 03 00 00       	jmp    801068ba <sys_open+0x48a>
    }
  }

  //.............................................................
  if((ip->type == T_FIFO) && !(omode & O_NBLOCK)) {
80106541:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106544:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80106548:	66 83 f8 04          	cmp    $0x4,%ax
8010654c:	0f 85 a8 02 00 00    	jne    801067fa <sys_open+0x3ca>
80106552:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106555:	83 e0 10             	and    $0x10,%eax
80106558:	85 c0                	test   %eax,%eax
8010655a:	0f 85 9a 02 00 00    	jne    801067fa <sys_open+0x3ca>
    if(ip->rf == 0 && ip->wf == 0) {
80106560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106563:	8b 40 10             	mov    0x10(%eax),%eax
80106566:	85 c0                	test   %eax,%eax
80106568:	0f 85 9e 00 00 00    	jne    8010660c <sys_open+0x1dc>
8010656e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106571:	8b 40 14             	mov    0x14(%eax),%eax
80106574:	85 c0                	test   %eax,%eax
80106576:	0f 85 90 00 00 00    	jne    8010660c <sys_open+0x1dc>
        if (pipealloc(&ip->rf, &ip->wf) < 0) {
8010657c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010657f:	8d 50 14             	lea    0x14(%eax),%edx
80106582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106585:	83 c0 10             	add    $0x10,%eax
80106588:	83 ec 08             	sub    $0x8,%esp
8010658b:	52                   	push   %edx
8010658c:	50                   	push   %eax
8010658d:	e8 85 dd ff ff       	call   80104317 <pipealloc>
80106592:	83 c4 10             	add    $0x10,%esp
80106595:	85 c0                	test   %eax,%eax
80106597:	79 1d                	jns    801065b6 <sys_open+0x186>
            iunlockput(ip);
80106599:	83 ec 0c             	sub    $0xc,%esp
8010659c:	ff 75 f4             	pushl  -0xc(%ebp)
8010659f:	e8 5c b9 ff ff       	call   80101f00 <iunlockput>
801065a4:	83 c4 10             	add    $0x10,%esp
            end_op();
801065a7:	e8 03 d3 ff ff       	call   801038af <end_op>
            return -1;
801065ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b1:	e9 04 03 00 00       	jmp    801068ba <sys_open+0x48a>
        }
        ip->rf->type = FD_FIFO;
801065b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b9:	8b 40 10             	mov    0x10(%eax),%eax
801065bc:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
        ip->wf->type = FD_FIFO;
801065c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c5:	8b 40 14             	mov    0x14(%eax),%eax
801065c8:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
        ip->rf->ip = ip;
801065ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d1:	8b 40 10             	mov    0x10(%eax),%eax
801065d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065d7:	89 50 10             	mov    %edx,0x10(%eax)
        ip->wf->ip = ip;
801065da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065dd:	8b 40 14             	mov    0x14(%eax),%eax
801065e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065e3:	89 50 10             	mov    %edx,0x10(%eax)
        p = ip->rf->pipe;
801065e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e9:	8b 40 10             	mov    0x10(%eax),%eax
801065ec:	8b 40 0c             	mov    0xc(%eax),%eax
801065ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
        p->writeopen = 0;
801065f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065f5:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801065fc:	00 00 00 
        p->readopen = 0;
801065ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106602:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80106609:	00 00 00 
    }
    if (omode & O_WRONLY) {
8010660c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010660f:	83 e0 01             	and    $0x1,%eax
80106612:	85 c0                	test   %eax,%eax
80106614:	0f 84 f0 00 00 00    	je     8010670a <sys_open+0x2da>
      ++ip->wf->pipe->writeopen;
8010661a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661d:	8b 40 14             	mov    0x14(%eax),%eax
80106620:	8b 40 0c             	mov    0xc(%eax),%eax
80106623:	8b 90 40 02 00 00    	mov    0x240(%eax),%edx
80106629:	83 c2 01             	add    $0x1,%edx
8010662c:	89 90 40 02 00 00    	mov    %edx,0x240(%eax)
      ++ip->wf->ref;
80106632:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106635:	8b 40 14             	mov    0x14(%eax),%eax
80106638:	8b 50 04             	mov    0x4(%eax),%edx
8010663b:	83 c2 01             	add    $0x1,%edx
8010663e:	89 50 04             	mov    %edx,0x4(%eax)
      fd = fdalloc(ip->wf);
80106641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106644:	8b 40 14             	mov    0x14(%eax),%eax
80106647:	83 ec 0c             	sub    $0xc,%esp
8010664a:	50                   	push   %eax
8010664b:	e8 ea f5 ff ff       	call   80105c3a <fdalloc>
80106650:	83 c4 10             	add    $0x10,%esp
80106653:	89 45 ec             	mov    %eax,-0x14(%ebp)
      iunlock(ip);
80106656:	83 ec 0c             	sub    $0xc,%esp
80106659:	ff 75 f4             	pushl  -0xc(%ebp)
8010665c:	e8 3d b7 ff ff       	call   80101d9e <iunlock>
80106661:	83 c4 10             	add    $0x10,%esp
      acquire(&(ip->wf->pipe)->lock);
80106664:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106667:	8b 40 14             	mov    0x14(%eax),%eax
8010666a:	8b 40 0c             	mov    0xc(%eax),%eax
8010666d:	83 ec 0c             	sub    $0xc,%esp
80106670:	50                   	push   %eax
80106671:	e8 74 ec ff ff       	call   801052ea <acquire>
80106676:	83 c4 10             	add    $0x10,%esp
      while (!(ip->wf->pipe)->readopen) {
80106679:	eb 40                	jmp    801066bb <sys_open+0x28b>
        wakeup(&(ip->wf->pipe)->nread);
8010667b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010667e:	8b 40 14             	mov    0x14(%eax),%eax
80106681:	8b 40 0c             	mov    0xc(%eax),%eax
80106684:	05 34 02 00 00       	add    $0x234,%eax
80106689:	83 ec 0c             	sub    $0xc,%esp
8010668c:	50                   	push   %eax
8010668d:	e8 44 ea ff ff       	call   801050d6 <wakeup>
80106692:	83 c4 10             	add    $0x10,%esp
        sleep(&(ip->wf->pipe)->nwrite, &(ip->wf->pipe)->lock);
80106695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106698:	8b 40 14             	mov    0x14(%eax),%eax
8010669b:	8b 40 0c             	mov    0xc(%eax),%eax
8010669e:	89 c2                	mov    %eax,%edx
801066a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a3:	8b 40 14             	mov    0x14(%eax),%eax
801066a6:	8b 40 0c             	mov    0xc(%eax),%eax
801066a9:	05 38 02 00 00       	add    $0x238,%eax
801066ae:	83 ec 08             	sub    $0x8,%esp
801066b1:	52                   	push   %edx
801066b2:	50                   	push   %eax
801066b3:	e8 30 e9 ff ff       	call   80104fe8 <sleep>
801066b8:	83 c4 10             	add    $0x10,%esp
      ++ip->wf->pipe->writeopen;
      ++ip->wf->ref;
      fd = fdalloc(ip->wf);
      iunlock(ip);
      acquire(&(ip->wf->pipe)->lock);
      while (!(ip->wf->pipe)->readopen) {
801066bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066be:	8b 40 14             	mov    0x14(%eax),%eax
801066c1:	8b 40 0c             	mov    0xc(%eax),%eax
801066c4:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801066ca:	85 c0                	test   %eax,%eax
801066cc:	74 ad                	je     8010667b <sys_open+0x24b>
        wakeup(&(ip->wf->pipe)->nread);
        sleep(&(ip->wf->pipe)->nwrite, &(ip->wf->pipe)->lock);
      }
      wakeup(&(ip->wf->pipe)->nread);
801066ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d1:	8b 40 14             	mov    0x14(%eax),%eax
801066d4:	8b 40 0c             	mov    0xc(%eax),%eax
801066d7:	05 34 02 00 00       	add    $0x234,%eax
801066dc:	83 ec 0c             	sub    $0xc,%esp
801066df:	50                   	push   %eax
801066e0:	e8 f1 e9 ff ff       	call   801050d6 <wakeup>
801066e5:	83 c4 10             	add    $0x10,%esp
      release(&(ip->wf->pipe)->lock);
801066e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066eb:	8b 40 14             	mov    0x14(%eax),%eax
801066ee:	8b 40 0c             	mov    0xc(%eax),%eax
801066f1:	83 ec 0c             	sub    $0xc,%esp
801066f4:	50                   	push   %eax
801066f5:	e8 57 ec ff ff       	call   80105351 <release>
801066fa:	83 c4 10             	add    $0x10,%esp
      end_op();
801066fd:	e8 ad d1 ff ff       	call   801038af <end_op>
      return fd;
80106702:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106705:	e9 b0 01 00 00       	jmp    801068ba <sys_open+0x48a>
    } else {
      ++ip->rf->pipe->readopen;
8010670a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670d:	8b 40 10             	mov    0x10(%eax),%eax
80106710:	8b 40 0c             	mov    0xc(%eax),%eax
80106713:	8b 90 3c 02 00 00    	mov    0x23c(%eax),%edx
80106719:	83 c2 01             	add    $0x1,%edx
8010671c:	89 90 3c 02 00 00    	mov    %edx,0x23c(%eax)
      ++ip->rf->ref;
80106722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106725:	8b 40 10             	mov    0x10(%eax),%eax
80106728:	8b 50 04             	mov    0x4(%eax),%edx
8010672b:	83 c2 01             	add    $0x1,%edx
8010672e:	89 50 04             	mov    %edx,0x4(%eax)
      fd = fdalloc(ip->rf);
80106731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106734:	8b 40 10             	mov    0x10(%eax),%eax
80106737:	83 ec 0c             	sub    $0xc,%esp
8010673a:	50                   	push   %eax
8010673b:	e8 fa f4 ff ff       	call   80105c3a <fdalloc>
80106740:	83 c4 10             	add    $0x10,%esp
80106743:	89 45 ec             	mov    %eax,-0x14(%ebp)
      iunlock(ip);
80106746:	83 ec 0c             	sub    $0xc,%esp
80106749:	ff 75 f4             	pushl  -0xc(%ebp)
8010674c:	e8 4d b6 ff ff       	call   80101d9e <iunlock>
80106751:	83 c4 10             	add    $0x10,%esp
      acquire(&(ip->rf->pipe)->lock);
80106754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106757:	8b 40 10             	mov    0x10(%eax),%eax
8010675a:	8b 40 0c             	mov    0xc(%eax),%eax
8010675d:	83 ec 0c             	sub    $0xc,%esp
80106760:	50                   	push   %eax
80106761:	e8 84 eb ff ff       	call   801052ea <acquire>
80106766:	83 c4 10             	add    $0x10,%esp
      while (!(ip->rf->pipe)->writeopen) {
80106769:	eb 40                	jmp    801067ab <sys_open+0x37b>
        wakeup(&(ip->rf->pipe)->nwrite);
8010676b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010676e:	8b 40 10             	mov    0x10(%eax),%eax
80106771:	8b 40 0c             	mov    0xc(%eax),%eax
80106774:	05 38 02 00 00       	add    $0x238,%eax
80106779:	83 ec 0c             	sub    $0xc,%esp
8010677c:	50                   	push   %eax
8010677d:	e8 54 e9 ff ff       	call   801050d6 <wakeup>
80106782:	83 c4 10             	add    $0x10,%esp
        sleep(&(ip->rf->pipe)->nread, &(ip->rf->pipe)->lock);
80106785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106788:	8b 40 10             	mov    0x10(%eax),%eax
8010678b:	8b 40 0c             	mov    0xc(%eax),%eax
8010678e:	89 c2                	mov    %eax,%edx
80106790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106793:	8b 40 10             	mov    0x10(%eax),%eax
80106796:	8b 40 0c             	mov    0xc(%eax),%eax
80106799:	05 34 02 00 00       	add    $0x234,%eax
8010679e:	83 ec 08             	sub    $0x8,%esp
801067a1:	52                   	push   %edx
801067a2:	50                   	push   %eax
801067a3:	e8 40 e8 ff ff       	call   80104fe8 <sleep>
801067a8:	83 c4 10             	add    $0x10,%esp
      ++ip->rf->pipe->readopen;
      ++ip->rf->ref;
      fd = fdalloc(ip->rf);
      iunlock(ip);
      acquire(&(ip->rf->pipe)->lock);
      while (!(ip->rf->pipe)->writeopen) {
801067ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ae:	8b 40 10             	mov    0x10(%eax),%eax
801067b1:	8b 40 0c             	mov    0xc(%eax),%eax
801067b4:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801067ba:	85 c0                	test   %eax,%eax
801067bc:	74 ad                	je     8010676b <sys_open+0x33b>
        wakeup(&(ip->rf->pipe)->nwrite);
        sleep(&(ip->rf->pipe)->nread, &(ip->rf->pipe)->lock);
      }
      wakeup(&(ip->rf->pipe)->nwrite);
801067be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c1:	8b 40 10             	mov    0x10(%eax),%eax
801067c4:	8b 40 0c             	mov    0xc(%eax),%eax
801067c7:	05 38 02 00 00       	add    $0x238,%eax
801067cc:	83 ec 0c             	sub    $0xc,%esp
801067cf:	50                   	push   %eax
801067d0:	e8 01 e9 ff ff       	call   801050d6 <wakeup>
801067d5:	83 c4 10             	add    $0x10,%esp
      release(&(ip->rf->pipe)->lock);
801067d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067db:	8b 40 10             	mov    0x10(%eax),%eax
801067de:	8b 40 0c             	mov    0xc(%eax),%eax
801067e1:	83 ec 0c             	sub    $0xc,%esp
801067e4:	50                   	push   %eax
801067e5:	e8 67 eb ff ff       	call   80105351 <release>
801067ea:	83 c4 10             	add    $0x10,%esp
      end_op();
801067ed:	e8 bd d0 ff ff       	call   801038af <end_op>
      return fd;
801067f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067f5:	e9 c0 00 00 00       	jmp    801068ba <sys_open+0x48a>
    }
    
  }
  //...................................................................

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801067fa:	e8 2f a9 ff ff       	call   8010112e <filealloc>
801067ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
80106802:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80106806:	74 17                	je     8010681f <sys_open+0x3ef>
80106808:	83 ec 0c             	sub    $0xc,%esp
8010680b:	ff 75 e8             	pushl  -0x18(%ebp)
8010680e:	e8 27 f4 ff ff       	call   80105c3a <fdalloc>
80106813:	83 c4 10             	add    $0x10,%esp
80106816:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106819:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010681d:	79 2e                	jns    8010684d <sys_open+0x41d>
    if(f)
8010681f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80106823:	74 0e                	je     80106833 <sys_open+0x403>
      fileclose(f);
80106825:	83 ec 0c             	sub    $0xc,%esp
80106828:	ff 75 e8             	pushl  -0x18(%ebp)
8010682b:	e8 bc a9 ff ff       	call   801011ec <fileclose>
80106830:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106833:	83 ec 0c             	sub    $0xc,%esp
80106836:	ff 75 f4             	pushl  -0xc(%ebp)
80106839:	e8 c2 b6 ff ff       	call   80101f00 <iunlockput>
8010683e:	83 c4 10             	add    $0x10,%esp
    end_op();
80106841:	e8 69 d0 ff ff       	call   801038af <end_op>
    return -1;
80106846:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684b:	eb 6d                	jmp    801068ba <sys_open+0x48a>
  }

  iunlock(ip);
8010684d:	83 ec 0c             	sub    $0xc,%esp
80106850:	ff 75 f4             	pushl  -0xc(%ebp)
80106853:	e8 46 b5 ff ff       	call   80101d9e <iunlock>
80106858:	83 c4 10             	add    $0x10,%esp
  end_op();
8010685b:	e8 4f d0 ff ff       	call   801038af <end_op>

  f->type = FD_INODE;
80106860:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106863:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106869:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010686c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010686f:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106872:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106875:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010687c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010687f:	83 e0 01             	and    $0x1,%eax
80106882:	85 c0                	test   %eax,%eax
80106884:	0f 94 c0             	sete   %al
80106887:	89 c2                	mov    %eax,%edx
80106889:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010688c:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010688f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106892:	83 e0 01             	and    $0x1,%eax
80106895:	85 c0                	test   %eax,%eax
80106897:	75 0a                	jne    801068a3 <sys_open+0x473>
80106899:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010689c:	83 e0 02             	and    $0x2,%eax
8010689f:	85 c0                	test   %eax,%eax
801068a1:	74 07                	je     801068aa <sys_open+0x47a>
801068a3:	b8 01 00 00 00       	mov    $0x1,%eax
801068a8:	eb 05                	jmp    801068af <sys_open+0x47f>
801068aa:	b8 00 00 00 00       	mov    $0x0,%eax
801068af:	89 c2                	mov    %eax,%edx
801068b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801068b4:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801068b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801068ba:	c9                   	leave  
801068bb:	c3                   	ret    

801068bc <sys_mkdir>:

int
sys_mkdir(void)
{
801068bc:	55                   	push   %ebp
801068bd:	89 e5                	mov    %esp,%ebp
801068bf:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801068c2:	e8 5c cf ff ff       	call   80103823 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801068c7:	83 ec 08             	sub    $0x8,%esp
801068ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068cd:	50                   	push   %eax
801068ce:	6a 00                	push   $0x0
801068d0:	e8 22 f0 ff ff       	call   801058f7 <argstr>
801068d5:	83 c4 10             	add    $0x10,%esp
801068d8:	85 c0                	test   %eax,%eax
801068da:	78 1b                	js     801068f7 <sys_mkdir+0x3b>
801068dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068df:	6a 00                	push   $0x0
801068e1:	6a 00                	push   $0x0
801068e3:	6a 01                	push   $0x1
801068e5:	50                   	push   %eax
801068e6:	e8 52 f9 ff ff       	call   8010623d <create>
801068eb:	83 c4 10             	add    $0x10,%esp
801068ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068f5:	75 0c                	jne    80106903 <sys_mkdir+0x47>
    end_op();
801068f7:	e8 b3 cf ff ff       	call   801038af <end_op>
    return -1;
801068fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106901:	eb 18                	jmp    8010691b <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106903:	83 ec 0c             	sub    $0xc,%esp
80106906:	ff 75 f4             	pushl  -0xc(%ebp)
80106909:	e8 f2 b5 ff ff       	call   80101f00 <iunlockput>
8010690e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106911:	e8 99 cf ff ff       	call   801038af <end_op>
  return 0;
80106916:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010691b:	c9                   	leave  
8010691c:	c3                   	ret    

8010691d <sys_mkfifo>:

int
sys_mkfifo(void)
{
8010691d:	55                   	push   %ebp
8010691e:	89 e5                	mov    %esp,%ebp
80106920:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106923:	e8 fb ce ff ff       	call   80103823 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_FIFO, 0, 0)) == 0) {
80106928:	83 ec 08             	sub    $0x8,%esp
8010692b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010692e:	50                   	push   %eax
8010692f:	6a 00                	push   $0x0
80106931:	e8 c1 ef ff ff       	call   801058f7 <argstr>
80106936:	83 c4 10             	add    $0x10,%esp
80106939:	85 c0                	test   %eax,%eax
8010693b:	78 1b                	js     80106958 <sys_mkfifo+0x3b>
8010693d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106940:	6a 00                	push   $0x0
80106942:	6a 00                	push   $0x0
80106944:	6a 04                	push   $0x4
80106946:	50                   	push   %eax
80106947:	e8 f1 f8 ff ff       	call   8010623d <create>
8010694c:	83 c4 10             	add    $0x10,%esp
8010694f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106952:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106956:	75 0c                	jne    80106964 <sys_mkfifo+0x47>
    end_op();
80106958:	e8 52 cf ff ff       	call   801038af <end_op>
    return -1;
8010695d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106962:	eb 18                	jmp    8010697c <sys_mkfifo+0x5f>
  }
  iunlockput(ip);
80106964:	83 ec 0c             	sub    $0xc,%esp
80106967:	ff 75 f4             	pushl  -0xc(%ebp)
8010696a:	e8 91 b5 ff ff       	call   80101f00 <iunlockput>
8010696f:	83 c4 10             	add    $0x10,%esp
  end_op();
80106972:	e8 38 cf ff ff       	call   801038af <end_op>
  return 0;
80106977:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010697c:	c9                   	leave  
8010697d:	c3                   	ret    

8010697e <sys_mknod>:

int
sys_mknod(void)
{
8010697e:	55                   	push   %ebp
8010697f:	89 e5                	mov    %esp,%ebp
80106981:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106984:	e8 9a ce ff ff       	call   80103823 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106989:	83 ec 08             	sub    $0x8,%esp
8010698c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010698f:	50                   	push   %eax
80106990:	6a 00                	push   $0x0
80106992:	e8 60 ef ff ff       	call   801058f7 <argstr>
80106997:	83 c4 10             	add    $0x10,%esp
8010699a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010699d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069a1:	78 4f                	js     801069f2 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801069a3:	83 ec 08             	sub    $0x8,%esp
801069a6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801069a9:	50                   	push   %eax
801069aa:	6a 01                	push   $0x1
801069ac:	e8 c1 ee ff ff       	call   80105872 <argint>
801069b1:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801069b4:	85 c0                	test   %eax,%eax
801069b6:	78 3a                	js     801069f2 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801069b8:	83 ec 08             	sub    $0x8,%esp
801069bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801069be:	50                   	push   %eax
801069bf:	6a 02                	push   $0x2
801069c1:	e8 ac ee ff ff       	call   80105872 <argint>
801069c6:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801069c9:	85 c0                	test   %eax,%eax
801069cb:	78 25                	js     801069f2 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801069cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069d0:	0f bf c8             	movswl %ax,%ecx
801069d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801069d6:	0f bf d0             	movswl %ax,%edx
801069d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801069dc:	51                   	push   %ecx
801069dd:	52                   	push   %edx
801069de:	6a 03                	push   $0x3
801069e0:	50                   	push   %eax
801069e1:	e8 57 f8 ff ff       	call   8010623d <create>
801069e6:	83 c4 10             	add    $0x10,%esp
801069e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801069ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801069f0:	75 0c                	jne    801069fe <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801069f2:	e8 b8 ce ff ff       	call   801038af <end_op>
    return -1;
801069f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069fc:	eb 18                	jmp    80106a16 <sys_mknod+0x98>
  }
  iunlockput(ip);
801069fe:	83 ec 0c             	sub    $0xc,%esp
80106a01:	ff 75 f0             	pushl  -0x10(%ebp)
80106a04:	e8 f7 b4 ff ff       	call   80101f00 <iunlockput>
80106a09:	83 c4 10             	add    $0x10,%esp
  end_op();
80106a0c:	e8 9e ce ff ff       	call   801038af <end_op>
  return 0;
80106a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a16:	c9                   	leave  
80106a17:	c3                   	ret    

80106a18 <sys_chdir>:

int
sys_chdir(void)
{
80106a18:	55                   	push   %ebp
80106a19:	89 e5                	mov    %esp,%ebp
80106a1b:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106a1e:	e8 00 ce ff ff       	call   80103823 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106a23:	83 ec 08             	sub    $0x8,%esp
80106a26:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a29:	50                   	push   %eax
80106a2a:	6a 00                	push   $0x0
80106a2c:	e8 c6 ee ff ff       	call   801058f7 <argstr>
80106a31:	83 c4 10             	add    $0x10,%esp
80106a34:	85 c0                	test   %eax,%eax
80106a36:	78 18                	js     80106a50 <sys_chdir+0x38>
80106a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a3b:	83 ec 0c             	sub    $0xc,%esp
80106a3e:	50                   	push   %eax
80106a3f:	e8 ba bd ff ff       	call   801027fe <namei>
80106a44:	83 c4 10             	add    $0x10,%esp
80106a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a4e:	75 0c                	jne    80106a5c <sys_chdir+0x44>
    end_op();
80106a50:	e8 5a ce ff ff       	call   801038af <end_op>
    return -1;
80106a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a5a:	eb 6e                	jmp    80106aca <sys_chdir+0xb2>
  }
  ilock(ip);
80106a5c:	83 ec 0c             	sub    $0xc,%esp
80106a5f:	ff 75 f4             	pushl  -0xc(%ebp)
80106a62:	e8 d9 b1 ff ff       	call   80101c40 <ilock>
80106a67:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a6d:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80106a71:	66 83 f8 01          	cmp    $0x1,%ax
80106a75:	74 1a                	je     80106a91 <sys_chdir+0x79>
    iunlockput(ip);
80106a77:	83 ec 0c             	sub    $0xc,%esp
80106a7a:	ff 75 f4             	pushl  -0xc(%ebp)
80106a7d:	e8 7e b4 ff ff       	call   80101f00 <iunlockput>
80106a82:	83 c4 10             	add    $0x10,%esp
    end_op();
80106a85:	e8 25 ce ff ff       	call   801038af <end_op>
    return -1;
80106a8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a8f:	eb 39                	jmp    80106aca <sys_chdir+0xb2>
  }
  iunlock(ip);
80106a91:	83 ec 0c             	sub    $0xc,%esp
80106a94:	ff 75 f4             	pushl  -0xc(%ebp)
80106a97:	e8 02 b3 ff ff       	call   80101d9e <iunlock>
80106a9c:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106a9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aa5:	8b 40 68             	mov    0x68(%eax),%eax
80106aa8:	83 ec 0c             	sub    $0xc,%esp
80106aab:	50                   	push   %eax
80106aac:	e8 5f b3 ff ff       	call   80101e10 <iput>
80106ab1:	83 c4 10             	add    $0x10,%esp
  end_op();
80106ab4:	e8 f6 cd ff ff       	call   801038af <end_op>
  proc->cwd = ip;
80106ab9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ac2:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106ac5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106aca:	c9                   	leave  
80106acb:	c3                   	ret    

80106acc <sys_exec>:

int
sys_exec(void)
{
80106acc:	55                   	push   %ebp
80106acd:	89 e5                	mov    %esp,%ebp
80106acf:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106ad5:	83 ec 08             	sub    $0x8,%esp
80106ad8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106adb:	50                   	push   %eax
80106adc:	6a 00                	push   $0x0
80106ade:	e8 14 ee ff ff       	call   801058f7 <argstr>
80106ae3:	83 c4 10             	add    $0x10,%esp
80106ae6:	85 c0                	test   %eax,%eax
80106ae8:	78 18                	js     80106b02 <sys_exec+0x36>
80106aea:	83 ec 08             	sub    $0x8,%esp
80106aed:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106af3:	50                   	push   %eax
80106af4:	6a 01                	push   $0x1
80106af6:	e8 77 ed ff ff       	call   80105872 <argint>
80106afb:	83 c4 10             	add    $0x10,%esp
80106afe:	85 c0                	test   %eax,%eax
80106b00:	79 0a                	jns    80106b0c <sys_exec+0x40>
    return -1;
80106b02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b07:	e9 c6 00 00 00       	jmp    80106bd2 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106b0c:	83 ec 04             	sub    $0x4,%esp
80106b0f:	68 80 00 00 00       	push   $0x80
80106b14:	6a 00                	push   $0x0
80106b16:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106b1c:	50                   	push   %eax
80106b1d:	e8 2b ea ff ff       	call   8010554d <memset>
80106b22:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106b25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2f:	83 f8 1f             	cmp    $0x1f,%eax
80106b32:	76 0a                	jbe    80106b3e <sys_exec+0x72>
      return -1;
80106b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b39:	e9 94 00 00 00       	jmp    80106bd2 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b41:	c1 e0 02             	shl    $0x2,%eax
80106b44:	89 c2                	mov    %eax,%edx
80106b46:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106b4c:	01 c2                	add    %eax,%edx
80106b4e:	83 ec 08             	sub    $0x8,%esp
80106b51:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106b57:	50                   	push   %eax
80106b58:	52                   	push   %edx
80106b59:	e8 78 ec ff ff       	call   801057d6 <fetchint>
80106b5e:	83 c4 10             	add    $0x10,%esp
80106b61:	85 c0                	test   %eax,%eax
80106b63:	79 07                	jns    80106b6c <sys_exec+0xa0>
      return -1;
80106b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b6a:	eb 66                	jmp    80106bd2 <sys_exec+0x106>
    if(uarg == 0){
80106b6c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106b72:	85 c0                	test   %eax,%eax
80106b74:	75 27                	jne    80106b9d <sys_exec+0xd1>
      argv[i] = 0;
80106b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b79:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106b80:	00 00 00 00 
      break;
80106b84:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b88:	83 ec 08             	sub    $0x8,%esp
80106b8b:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106b91:	52                   	push   %edx
80106b92:	50                   	push   %eax
80106b93:	e8 f9 9f ff ff       	call   80100b91 <exec>
80106b98:	83 c4 10             	add    $0x10,%esp
80106b9b:	eb 35                	jmp    80106bd2 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106b9d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ba6:	c1 e2 02             	shl    $0x2,%edx
80106ba9:	01 c2                	add    %eax,%edx
80106bab:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106bb1:	83 ec 08             	sub    $0x8,%esp
80106bb4:	52                   	push   %edx
80106bb5:	50                   	push   %eax
80106bb6:	e8 55 ec ff ff       	call   80105810 <fetchstr>
80106bbb:	83 c4 10             	add    $0x10,%esp
80106bbe:	85 c0                	test   %eax,%eax
80106bc0:	79 07                	jns    80106bc9 <sys_exec+0xfd>
      return -1;
80106bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc7:	eb 09                	jmp    80106bd2 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106bc9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106bcd:	e9 5a ff ff ff       	jmp    80106b2c <sys_exec+0x60>
  return exec(path, argv);
}
80106bd2:	c9                   	leave  
80106bd3:	c3                   	ret    

80106bd4 <sys_pipe>:

int
sys_pipe(void)
{
80106bd4:	55                   	push   %ebp
80106bd5:	89 e5                	mov    %esp,%ebp
80106bd7:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106bda:	83 ec 04             	sub    $0x4,%esp
80106bdd:	6a 08                	push   $0x8
80106bdf:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106be2:	50                   	push   %eax
80106be3:	6a 00                	push   $0x0
80106be5:	e8 b0 ec ff ff       	call   8010589a <argptr>
80106bea:	83 c4 10             	add    $0x10,%esp
80106bed:	85 c0                	test   %eax,%eax
80106bef:	79 0a                	jns    80106bfb <sys_pipe+0x27>
    return -1;
80106bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bf6:	e9 af 00 00 00       	jmp    80106caa <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106bfb:	83 ec 08             	sub    $0x8,%esp
80106bfe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106c01:	50                   	push   %eax
80106c02:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106c05:	50                   	push   %eax
80106c06:	e8 0c d7 ff ff       	call   80104317 <pipealloc>
80106c0b:	83 c4 10             	add    $0x10,%esp
80106c0e:	85 c0                	test   %eax,%eax
80106c10:	79 0a                	jns    80106c1c <sys_pipe+0x48>
    return -1;
80106c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c17:	e9 8e 00 00 00       	jmp    80106caa <sys_pipe+0xd6>
  fd0 = -1;
80106c1c:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106c23:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106c26:	83 ec 0c             	sub    $0xc,%esp
80106c29:	50                   	push   %eax
80106c2a:	e8 0b f0 ff ff       	call   80105c3a <fdalloc>
80106c2f:	83 c4 10             	add    $0x10,%esp
80106c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c39:	78 18                	js     80106c53 <sys_pipe+0x7f>
80106c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c3e:	83 ec 0c             	sub    $0xc,%esp
80106c41:	50                   	push   %eax
80106c42:	e8 f3 ef ff ff       	call   80105c3a <fdalloc>
80106c47:	83 c4 10             	add    $0x10,%esp
80106c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106c51:	79 3f                	jns    80106c92 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106c53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c57:	78 14                	js     80106c6d <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106c59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c62:	83 c2 08             	add    $0x8,%edx
80106c65:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106c6c:	00 
    fileclose(rf);
80106c6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106c70:	83 ec 0c             	sub    $0xc,%esp
80106c73:	50                   	push   %eax
80106c74:	e8 73 a5 ff ff       	call   801011ec <fileclose>
80106c79:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106c7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c7f:	83 ec 0c             	sub    $0xc,%esp
80106c82:	50                   	push   %eax
80106c83:	e8 64 a5 ff ff       	call   801011ec <fileclose>
80106c88:	83 c4 10             	add    $0x10,%esp
    return -1;
80106c8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c90:	eb 18                	jmp    80106caa <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c98:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106c9d:	8d 50 04             	lea    0x4(%eax),%edx
80106ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ca3:	89 02                	mov    %eax,(%edx)
  return 0;
80106ca5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106caa:	c9                   	leave  
80106cab:	c3                   	ret    

80106cac <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106cac:	55                   	push   %ebp
80106cad:	89 e5                	mov    %esp,%ebp
80106caf:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106cb2:	e8 59 dd ff ff       	call   80104a10 <fork>
}
80106cb7:	c9                   	leave  
80106cb8:	c3                   	ret    

80106cb9 <sys_exit>:

int
sys_exit(void)
{
80106cb9:	55                   	push   %ebp
80106cba:	89 e5                	mov    %esp,%ebp
80106cbc:	83 ec 08             	sub    $0x8,%esp
  exit();
80106cbf:	e8 dd de ff ff       	call   80104ba1 <exit>
  return 0;  // not reached
80106cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106cc9:	c9                   	leave  
80106cca:	c3                   	ret    

80106ccb <sys_wait>:

int
sys_wait(void)
{
80106ccb:	55                   	push   %ebp
80106ccc:	89 e5                	mov    %esp,%ebp
80106cce:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106cd1:	e8 06 e0 ff ff       	call   80104cdc <wait>
}
80106cd6:	c9                   	leave  
80106cd7:	c3                   	ret    

80106cd8 <sys_kill>:

int
sys_kill(void)
{
80106cd8:	55                   	push   %ebp
80106cd9:	89 e5                	mov    %esp,%ebp
80106cdb:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106cde:	83 ec 08             	sub    $0x8,%esp
80106ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ce4:	50                   	push   %eax
80106ce5:	6a 00                	push   $0x0
80106ce7:	e8 86 eb ff ff       	call   80105872 <argint>
80106cec:	83 c4 10             	add    $0x10,%esp
80106cef:	85 c0                	test   %eax,%eax
80106cf1:	79 07                	jns    80106cfa <sys_kill+0x22>
    return -1;
80106cf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cf8:	eb 0f                	jmp    80106d09 <sys_kill+0x31>
  return kill(pid);
80106cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cfd:	83 ec 0c             	sub    $0xc,%esp
80106d00:	50                   	push   %eax
80106d01:	e8 07 e4 ff ff       	call   8010510d <kill>
80106d06:	83 c4 10             	add    $0x10,%esp
}
80106d09:	c9                   	leave  
80106d0a:	c3                   	ret    

80106d0b <sys_getpid>:

int
sys_getpid(void)
{
80106d0b:	55                   	push   %ebp
80106d0c:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106d0e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d14:	8b 40 10             	mov    0x10(%eax),%eax
}
80106d17:	5d                   	pop    %ebp
80106d18:	c3                   	ret    

80106d19 <sys_sbrk>:

int
sys_sbrk(void)
{
80106d19:	55                   	push   %ebp
80106d1a:	89 e5                	mov    %esp,%ebp
80106d1c:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106d1f:	83 ec 08             	sub    $0x8,%esp
80106d22:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d25:	50                   	push   %eax
80106d26:	6a 00                	push   $0x0
80106d28:	e8 45 eb ff ff       	call   80105872 <argint>
80106d2d:	83 c4 10             	add    $0x10,%esp
80106d30:	85 c0                	test   %eax,%eax
80106d32:	79 07                	jns    80106d3b <sys_sbrk+0x22>
    return -1;
80106d34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d39:	eb 28                	jmp    80106d63 <sys_sbrk+0x4a>
  addr = proc->sz;
80106d3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d41:	8b 00                	mov    (%eax),%eax
80106d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d49:	83 ec 0c             	sub    $0xc,%esp
80106d4c:	50                   	push   %eax
80106d4d:	e8 1b dc ff ff       	call   8010496d <growproc>
80106d52:	83 c4 10             	add    $0x10,%esp
80106d55:	85 c0                	test   %eax,%eax
80106d57:	79 07                	jns    80106d60 <sys_sbrk+0x47>
    return -1;
80106d59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d5e:	eb 03                	jmp    80106d63 <sys_sbrk+0x4a>
  return addr;
80106d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106d63:	c9                   	leave  
80106d64:	c3                   	ret    

80106d65 <sys_sleep>:

int
sys_sleep(void)
{
80106d65:	55                   	push   %ebp
80106d66:	89 e5                	mov    %esp,%ebp
80106d68:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106d6b:	83 ec 08             	sub    $0x8,%esp
80106d6e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d71:	50                   	push   %eax
80106d72:	6a 00                	push   $0x0
80106d74:	e8 f9 ea ff ff       	call   80105872 <argint>
80106d79:	83 c4 10             	add    $0x10,%esp
80106d7c:	85 c0                	test   %eax,%eax
80106d7e:	79 07                	jns    80106d87 <sys_sleep+0x22>
    return -1;
80106d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d85:	eb 77                	jmp    80106dfe <sys_sleep+0x99>
  acquire(&tickslock);
80106d87:	83 ec 0c             	sub    $0xc,%esp
80106d8a:	68 c0 5d 11 80       	push   $0x80115dc0
80106d8f:	e8 56 e5 ff ff       	call   801052ea <acquire>
80106d94:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106d97:	a1 00 66 11 80       	mov    0x80116600,%eax
80106d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106d9f:	eb 39                	jmp    80106dda <sys_sleep+0x75>
    if(proc->killed){
80106da1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106da7:	8b 40 24             	mov    0x24(%eax),%eax
80106daa:	85 c0                	test   %eax,%eax
80106dac:	74 17                	je     80106dc5 <sys_sleep+0x60>
      release(&tickslock);
80106dae:	83 ec 0c             	sub    $0xc,%esp
80106db1:	68 c0 5d 11 80       	push   $0x80115dc0
80106db6:	e8 96 e5 ff ff       	call   80105351 <release>
80106dbb:	83 c4 10             	add    $0x10,%esp
      return -1;
80106dbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dc3:	eb 39                	jmp    80106dfe <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106dc5:	83 ec 08             	sub    $0x8,%esp
80106dc8:	68 c0 5d 11 80       	push   $0x80115dc0
80106dcd:	68 00 66 11 80       	push   $0x80116600
80106dd2:	e8 11 e2 ff ff       	call   80104fe8 <sleep>
80106dd7:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106dda:	a1 00 66 11 80       	mov    0x80116600,%eax
80106ddf:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106de2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106de5:	39 d0                	cmp    %edx,%eax
80106de7:	72 b8                	jb     80106da1 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106de9:	83 ec 0c             	sub    $0xc,%esp
80106dec:	68 c0 5d 11 80       	push   $0x80115dc0
80106df1:	e8 5b e5 ff ff       	call   80105351 <release>
80106df6:	83 c4 10             	add    $0x10,%esp
  return 0;
80106df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106dfe:	c9                   	leave  
80106dff:	c3                   	ret    

80106e00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106e06:	83 ec 0c             	sub    $0xc,%esp
80106e09:	68 c0 5d 11 80       	push   $0x80115dc0
80106e0e:	e8 d7 e4 ff ff       	call   801052ea <acquire>
80106e13:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106e16:	a1 00 66 11 80       	mov    0x80116600,%eax
80106e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106e1e:	83 ec 0c             	sub    $0xc,%esp
80106e21:	68 c0 5d 11 80       	push   $0x80115dc0
80106e26:	e8 26 e5 ff ff       	call   80105351 <release>
80106e2b:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106e31:	c9                   	leave  
80106e32:	c3                   	ret    

80106e33 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106e33:	55                   	push   %ebp
80106e34:	89 e5                	mov    %esp,%ebp
80106e36:	83 ec 08             	sub    $0x8,%esp
80106e39:	8b 55 08             	mov    0x8(%ebp),%edx
80106e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e3f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106e43:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e46:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106e4a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106e4e:	ee                   	out    %al,(%dx)
}
80106e4f:	90                   	nop
80106e50:	c9                   	leave  
80106e51:	c3                   	ret    

80106e52 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106e52:	55                   	push   %ebp
80106e53:	89 e5                	mov    %esp,%ebp
80106e55:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106e58:	6a 34                	push   $0x34
80106e5a:	6a 43                	push   $0x43
80106e5c:	e8 d2 ff ff ff       	call   80106e33 <outb>
80106e61:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106e64:	68 9c 00 00 00       	push   $0x9c
80106e69:	6a 40                	push   $0x40
80106e6b:	e8 c3 ff ff ff       	call   80106e33 <outb>
80106e70:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106e73:	6a 2e                	push   $0x2e
80106e75:	6a 40                	push   $0x40
80106e77:	e8 b7 ff ff ff       	call   80106e33 <outb>
80106e7c:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106e7f:	83 ec 0c             	sub    $0xc,%esp
80106e82:	6a 00                	push   $0x0
80106e84:	e8 78 d3 ff ff       	call   80104201 <picenable>
80106e89:	83 c4 10             	add    $0x10,%esp
}
80106e8c:	90                   	nop
80106e8d:	c9                   	leave  
80106e8e:	c3                   	ret    

80106e8f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106e8f:	1e                   	push   %ds
  pushl %es
80106e90:	06                   	push   %es
  pushl %fs
80106e91:	0f a0                	push   %fs
  pushl %gs
80106e93:	0f a8                	push   %gs
  pushal
80106e95:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106e96:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106e9a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106e9c:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106e9e:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106ea2:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106ea4:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106ea6:	54                   	push   %esp
  call trap
80106ea7:	e8 d7 01 00 00       	call   80107083 <trap>
  addl $4, %esp
80106eac:	83 c4 04             	add    $0x4,%esp

80106eaf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106eaf:	61                   	popa   
  popl %gs
80106eb0:	0f a9                	pop    %gs
  popl %fs
80106eb2:	0f a1                	pop    %fs
  popl %es
80106eb4:	07                   	pop    %es
  popl %ds
80106eb5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106eb6:	83 c4 08             	add    $0x8,%esp
  iret
80106eb9:	cf                   	iret   

80106eba <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106eba:	55                   	push   %ebp
80106ebb:	89 e5                	mov    %esp,%ebp
80106ebd:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ec3:	83 e8 01             	sub    $0x1,%eax
80106ec6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106eca:	8b 45 08             	mov    0x8(%ebp),%eax
80106ecd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed4:	c1 e8 10             	shr    $0x10,%eax
80106ed7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106edb:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ede:	0f 01 18             	lidtl  (%eax)
}
80106ee1:	90                   	nop
80106ee2:	c9                   	leave  
80106ee3:	c3                   	ret    

80106ee4 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106ee4:	55                   	push   %ebp
80106ee5:	89 e5                	mov    %esp,%ebp
80106ee7:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106eea:	0f 20 d0             	mov    %cr2,%eax
80106eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106ef3:	c9                   	leave  
80106ef4:	c3                   	ret    

80106ef5 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106ef5:	55                   	push   %ebp
80106ef6:	89 e5                	mov    %esp,%ebp
80106ef8:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106efb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106f02:	e9 c3 00 00 00       	jmp    80106fca <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f0a:	8b 04 85 d0 c0 10 80 	mov    -0x7fef3f30(,%eax,4),%eax
80106f11:	89 c2                	mov    %eax,%edx
80106f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f16:	66 89 14 c5 00 5e 11 	mov    %dx,-0x7feea200(,%eax,8)
80106f1d:	80 
80106f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f21:	66 c7 04 c5 02 5e 11 	movw   $0x8,-0x7feea1fe(,%eax,8)
80106f28:	80 08 00 
80106f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f2e:	0f b6 14 c5 04 5e 11 	movzbl -0x7feea1fc(,%eax,8),%edx
80106f35:	80 
80106f36:	83 e2 e0             	and    $0xffffffe0,%edx
80106f39:	88 14 c5 04 5e 11 80 	mov    %dl,-0x7feea1fc(,%eax,8)
80106f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f43:	0f b6 14 c5 04 5e 11 	movzbl -0x7feea1fc(,%eax,8),%edx
80106f4a:	80 
80106f4b:	83 e2 1f             	and    $0x1f,%edx
80106f4e:	88 14 c5 04 5e 11 80 	mov    %dl,-0x7feea1fc(,%eax,8)
80106f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f58:	0f b6 14 c5 05 5e 11 	movzbl -0x7feea1fb(,%eax,8),%edx
80106f5f:	80 
80106f60:	83 e2 f0             	and    $0xfffffff0,%edx
80106f63:	83 ca 0e             	or     $0xe,%edx
80106f66:	88 14 c5 05 5e 11 80 	mov    %dl,-0x7feea1fb(,%eax,8)
80106f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f70:	0f b6 14 c5 05 5e 11 	movzbl -0x7feea1fb(,%eax,8),%edx
80106f77:	80 
80106f78:	83 e2 ef             	and    $0xffffffef,%edx
80106f7b:	88 14 c5 05 5e 11 80 	mov    %dl,-0x7feea1fb(,%eax,8)
80106f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f85:	0f b6 14 c5 05 5e 11 	movzbl -0x7feea1fb(,%eax,8),%edx
80106f8c:	80 
80106f8d:	83 e2 9f             	and    $0xffffff9f,%edx
80106f90:	88 14 c5 05 5e 11 80 	mov    %dl,-0x7feea1fb(,%eax,8)
80106f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f9a:	0f b6 14 c5 05 5e 11 	movzbl -0x7feea1fb(,%eax,8),%edx
80106fa1:	80 
80106fa2:	83 ca 80             	or     $0xffffff80,%edx
80106fa5:	88 14 c5 05 5e 11 80 	mov    %dl,-0x7feea1fb(,%eax,8)
80106fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106faf:	8b 04 85 d0 c0 10 80 	mov    -0x7fef3f30(,%eax,4),%eax
80106fb6:	c1 e8 10             	shr    $0x10,%eax
80106fb9:	89 c2                	mov    %eax,%edx
80106fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fbe:	66 89 14 c5 06 5e 11 	mov    %dx,-0x7feea1fa(,%eax,8)
80106fc5:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106fc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106fca:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106fd1:	0f 8e 30 ff ff ff    	jle    80106f07 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106fd7:	a1 d0 c1 10 80       	mov    0x8010c1d0,%eax
80106fdc:	66 a3 00 60 11 80    	mov    %ax,0x80116000
80106fe2:	66 c7 05 02 60 11 80 	movw   $0x8,0x80116002
80106fe9:	08 00 
80106feb:	0f b6 05 04 60 11 80 	movzbl 0x80116004,%eax
80106ff2:	83 e0 e0             	and    $0xffffffe0,%eax
80106ff5:	a2 04 60 11 80       	mov    %al,0x80116004
80106ffa:	0f b6 05 04 60 11 80 	movzbl 0x80116004,%eax
80107001:	83 e0 1f             	and    $0x1f,%eax
80107004:	a2 04 60 11 80       	mov    %al,0x80116004
80107009:	0f b6 05 05 60 11 80 	movzbl 0x80116005,%eax
80107010:	83 c8 0f             	or     $0xf,%eax
80107013:	a2 05 60 11 80       	mov    %al,0x80116005
80107018:	0f b6 05 05 60 11 80 	movzbl 0x80116005,%eax
8010701f:	83 e0 ef             	and    $0xffffffef,%eax
80107022:	a2 05 60 11 80       	mov    %al,0x80116005
80107027:	0f b6 05 05 60 11 80 	movzbl 0x80116005,%eax
8010702e:	83 c8 60             	or     $0x60,%eax
80107031:	a2 05 60 11 80       	mov    %al,0x80116005
80107036:	0f b6 05 05 60 11 80 	movzbl 0x80116005,%eax
8010703d:	83 c8 80             	or     $0xffffff80,%eax
80107040:	a2 05 60 11 80       	mov    %al,0x80116005
80107045:	a1 d0 c1 10 80       	mov    0x8010c1d0,%eax
8010704a:	c1 e8 10             	shr    $0x10,%eax
8010704d:	66 a3 06 60 11 80    	mov    %ax,0x80116006
  
  initlock(&tickslock, "time");
80107053:	83 ec 08             	sub    $0x8,%esp
80107056:	68 60 92 10 80       	push   $0x80109260
8010705b:	68 c0 5d 11 80       	push   $0x80115dc0
80107060:	e8 63 e2 ff ff       	call   801052c8 <initlock>
80107065:	83 c4 10             	add    $0x10,%esp
}
80107068:	90                   	nop
80107069:	c9                   	leave  
8010706a:	c3                   	ret    

8010706b <idtinit>:

void
idtinit(void)
{
8010706b:	55                   	push   %ebp
8010706c:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010706e:	68 00 08 00 00       	push   $0x800
80107073:	68 00 5e 11 80       	push   $0x80115e00
80107078:	e8 3d fe ff ff       	call   80106eba <lidt>
8010707d:	83 c4 08             	add    $0x8,%esp
}
80107080:	90                   	nop
80107081:	c9                   	leave  
80107082:	c3                   	ret    

80107083 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107083:	55                   	push   %ebp
80107084:	89 e5                	mov    %esp,%ebp
80107086:	57                   	push   %edi
80107087:	56                   	push   %esi
80107088:	53                   	push   %ebx
80107089:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010708c:	8b 45 08             	mov    0x8(%ebp),%eax
8010708f:	8b 40 30             	mov    0x30(%eax),%eax
80107092:	83 f8 40             	cmp    $0x40,%eax
80107095:	75 3e                	jne    801070d5 <trap+0x52>
    if(proc->killed)
80107097:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010709d:	8b 40 24             	mov    0x24(%eax),%eax
801070a0:	85 c0                	test   %eax,%eax
801070a2:	74 05                	je     801070a9 <trap+0x26>
      exit();
801070a4:	e8 f8 da ff ff       	call   80104ba1 <exit>
    proc->tf = tf;
801070a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070af:	8b 55 08             	mov    0x8(%ebp),%edx
801070b2:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801070b5:	e8 6e e8 ff ff       	call   80105928 <syscall>
    if(proc->killed)
801070ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070c0:	8b 40 24             	mov    0x24(%eax),%eax
801070c3:	85 c0                	test   %eax,%eax
801070c5:	0f 84 1b 02 00 00    	je     801072e6 <trap+0x263>
      exit();
801070cb:	e8 d1 da ff ff       	call   80104ba1 <exit>
    return;
801070d0:	e9 11 02 00 00       	jmp    801072e6 <trap+0x263>
  }

  switch(tf->trapno){
801070d5:	8b 45 08             	mov    0x8(%ebp),%eax
801070d8:	8b 40 30             	mov    0x30(%eax),%eax
801070db:	83 e8 20             	sub    $0x20,%eax
801070de:	83 f8 1f             	cmp    $0x1f,%eax
801070e1:	0f 87 c0 00 00 00    	ja     801071a7 <trap+0x124>
801070e7:	8b 04 85 08 93 10 80 	mov    -0x7fef6cf8(,%eax,4),%eax
801070ee:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801070f0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801070f6:	0f b6 00             	movzbl (%eax),%eax
801070f9:	84 c0                	test   %al,%al
801070fb:	75 3d                	jne    8010713a <trap+0xb7>
      acquire(&tickslock);
801070fd:	83 ec 0c             	sub    $0xc,%esp
80107100:	68 c0 5d 11 80       	push   $0x80115dc0
80107105:	e8 e0 e1 ff ff       	call   801052ea <acquire>
8010710a:	83 c4 10             	add    $0x10,%esp
      ticks++;
8010710d:	a1 00 66 11 80       	mov    0x80116600,%eax
80107112:	83 c0 01             	add    $0x1,%eax
80107115:	a3 00 66 11 80       	mov    %eax,0x80116600
      wakeup(&ticks);
8010711a:	83 ec 0c             	sub    $0xc,%esp
8010711d:	68 00 66 11 80       	push   $0x80116600
80107122:	e8 af df ff ff       	call   801050d6 <wakeup>
80107127:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
8010712a:	83 ec 0c             	sub    $0xc,%esp
8010712d:	68 c0 5d 11 80       	push   $0x80115dc0
80107132:	e8 1a e2 ff ff       	call   80105351 <release>
80107137:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010713a:	e8 bc c1 ff ff       	call   801032fb <lapiceoi>
    break;
8010713f:	e9 1c 01 00 00       	jmp    80107260 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107144:	e8 c5 b9 ff ff       	call   80102b0e <ideintr>
    lapiceoi();
80107149:	e8 ad c1 ff ff       	call   801032fb <lapiceoi>
    break;
8010714e:	e9 0d 01 00 00       	jmp    80107260 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107153:	e8 a5 bf ff ff       	call   801030fd <kbdintr>
    lapiceoi();
80107158:	e8 9e c1 ff ff       	call   801032fb <lapiceoi>
    break;
8010715d:	e9 fe 00 00 00       	jmp    80107260 <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107162:	e8 60 03 00 00       	call   801074c7 <uartintr>
    lapiceoi();
80107167:	e8 8f c1 ff ff       	call   801032fb <lapiceoi>
    break;
8010716c:	e9 ef 00 00 00       	jmp    80107260 <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107171:	8b 45 08             	mov    0x8(%ebp),%eax
80107174:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107177:	8b 45 08             	mov    0x8(%ebp),%eax
8010717a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010717e:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107181:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107187:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010718a:	0f b6 c0             	movzbl %al,%eax
8010718d:	51                   	push   %ecx
8010718e:	52                   	push   %edx
8010718f:	50                   	push   %eax
80107190:	68 68 92 10 80       	push   $0x80109268
80107195:	e8 2c 92 ff ff       	call   801003c6 <cprintf>
8010719a:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010719d:	e8 59 c1 ff ff       	call   801032fb <lapiceoi>
    break;
801071a2:	e9 b9 00 00 00       	jmp    80107260 <trap+0x1dd>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801071a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071ad:	85 c0                	test   %eax,%eax
801071af:	74 11                	je     801071c2 <trap+0x13f>
801071b1:	8b 45 08             	mov    0x8(%ebp),%eax
801071b4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071b8:	0f b7 c0             	movzwl %ax,%eax
801071bb:	83 e0 03             	and    $0x3,%eax
801071be:	85 c0                	test   %eax,%eax
801071c0:	75 40                	jne    80107202 <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801071c2:	e8 1d fd ff ff       	call   80106ee4 <rcr2>
801071c7:	89 c3                	mov    %eax,%ebx
801071c9:	8b 45 08             	mov    0x8(%ebp),%eax
801071cc:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801071cf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071d5:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801071d8:	0f b6 d0             	movzbl %al,%edx
801071db:	8b 45 08             	mov    0x8(%ebp),%eax
801071de:	8b 40 30             	mov    0x30(%eax),%eax
801071e1:	83 ec 0c             	sub    $0xc,%esp
801071e4:	53                   	push   %ebx
801071e5:	51                   	push   %ecx
801071e6:	52                   	push   %edx
801071e7:	50                   	push   %eax
801071e8:	68 8c 92 10 80       	push   $0x8010928c
801071ed:	e8 d4 91 ff ff       	call   801003c6 <cprintf>
801071f2:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801071f5:	83 ec 0c             	sub    $0xc,%esp
801071f8:	68 be 92 10 80       	push   $0x801092be
801071fd:	e8 64 93 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107202:	e8 dd fc ff ff       	call   80106ee4 <rcr2>
80107207:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010720a:	8b 45 08             	mov    0x8(%ebp),%eax
8010720d:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107210:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107216:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107219:	0f b6 d8             	movzbl %al,%ebx
8010721c:	8b 45 08             	mov    0x8(%ebp),%eax
8010721f:	8b 48 34             	mov    0x34(%eax),%ecx
80107222:	8b 45 08             	mov    0x8(%ebp),%eax
80107225:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107228:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010722e:	8d 78 6c             	lea    0x6c(%eax),%edi
80107231:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107237:	8b 40 10             	mov    0x10(%eax),%eax
8010723a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010723d:	56                   	push   %esi
8010723e:	53                   	push   %ebx
8010723f:	51                   	push   %ecx
80107240:	52                   	push   %edx
80107241:	57                   	push   %edi
80107242:	50                   	push   %eax
80107243:	68 c4 92 10 80       	push   $0x801092c4
80107248:	e8 79 91 ff ff       	call   801003c6 <cprintf>
8010724d:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107250:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107256:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010725d:	eb 01                	jmp    80107260 <trap+0x1dd>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010725f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107260:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107266:	85 c0                	test   %eax,%eax
80107268:	74 24                	je     8010728e <trap+0x20b>
8010726a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107270:	8b 40 24             	mov    0x24(%eax),%eax
80107273:	85 c0                	test   %eax,%eax
80107275:	74 17                	je     8010728e <trap+0x20b>
80107277:	8b 45 08             	mov    0x8(%ebp),%eax
8010727a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010727e:	0f b7 c0             	movzwl %ax,%eax
80107281:	83 e0 03             	and    $0x3,%eax
80107284:	83 f8 03             	cmp    $0x3,%eax
80107287:	75 05                	jne    8010728e <trap+0x20b>
    exit();
80107289:	e8 13 d9 ff ff       	call   80104ba1 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010728e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107294:	85 c0                	test   %eax,%eax
80107296:	74 1e                	je     801072b6 <trap+0x233>
80107298:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010729e:	8b 40 0c             	mov    0xc(%eax),%eax
801072a1:	83 f8 04             	cmp    $0x4,%eax
801072a4:	75 10                	jne    801072b6 <trap+0x233>
801072a6:	8b 45 08             	mov    0x8(%ebp),%eax
801072a9:	8b 40 30             	mov    0x30(%eax),%eax
801072ac:	83 f8 20             	cmp    $0x20,%eax
801072af:	75 05                	jne    801072b6 <trap+0x233>
    yield();
801072b1:	e8 b1 dc ff ff       	call   80104f67 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801072b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072bc:	85 c0                	test   %eax,%eax
801072be:	74 27                	je     801072e7 <trap+0x264>
801072c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072c6:	8b 40 24             	mov    0x24(%eax),%eax
801072c9:	85 c0                	test   %eax,%eax
801072cb:	74 1a                	je     801072e7 <trap+0x264>
801072cd:	8b 45 08             	mov    0x8(%ebp),%eax
801072d0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801072d4:	0f b7 c0             	movzwl %ax,%eax
801072d7:	83 e0 03             	and    $0x3,%eax
801072da:	83 f8 03             	cmp    $0x3,%eax
801072dd:	75 08                	jne    801072e7 <trap+0x264>
    exit();
801072df:	e8 bd d8 ff ff       	call   80104ba1 <exit>
801072e4:	eb 01                	jmp    801072e7 <trap+0x264>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801072e6:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801072e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ea:	5b                   	pop    %ebx
801072eb:	5e                   	pop    %esi
801072ec:	5f                   	pop    %edi
801072ed:	5d                   	pop    %ebp
801072ee:	c3                   	ret    

801072ef <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801072ef:	55                   	push   %ebp
801072f0:	89 e5                	mov    %esp,%ebp
801072f2:	83 ec 14             	sub    $0x14,%esp
801072f5:	8b 45 08             	mov    0x8(%ebp),%eax
801072f8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801072fc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107300:	89 c2                	mov    %eax,%edx
80107302:	ec                   	in     (%dx),%al
80107303:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107306:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010730a:	c9                   	leave  
8010730b:	c3                   	ret    

8010730c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010730c:	55                   	push   %ebp
8010730d:	89 e5                	mov    %esp,%ebp
8010730f:	83 ec 08             	sub    $0x8,%esp
80107312:	8b 55 08             	mov    0x8(%ebp),%edx
80107315:	8b 45 0c             	mov    0xc(%ebp),%eax
80107318:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010731c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010731f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107323:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107327:	ee                   	out    %al,(%dx)
}
80107328:	90                   	nop
80107329:	c9                   	leave  
8010732a:	c3                   	ret    

8010732b <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010732b:	55                   	push   %ebp
8010732c:	89 e5                	mov    %esp,%ebp
8010732e:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107331:	6a 00                	push   $0x0
80107333:	68 fa 03 00 00       	push   $0x3fa
80107338:	e8 cf ff ff ff       	call   8010730c <outb>
8010733d:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107340:	68 80 00 00 00       	push   $0x80
80107345:	68 fb 03 00 00       	push   $0x3fb
8010734a:	e8 bd ff ff ff       	call   8010730c <outb>
8010734f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107352:	6a 0c                	push   $0xc
80107354:	68 f8 03 00 00       	push   $0x3f8
80107359:	e8 ae ff ff ff       	call   8010730c <outb>
8010735e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107361:	6a 00                	push   $0x0
80107363:	68 f9 03 00 00       	push   $0x3f9
80107368:	e8 9f ff ff ff       	call   8010730c <outb>
8010736d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107370:	6a 03                	push   $0x3
80107372:	68 fb 03 00 00       	push   $0x3fb
80107377:	e8 90 ff ff ff       	call   8010730c <outb>
8010737c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010737f:	6a 00                	push   $0x0
80107381:	68 fc 03 00 00       	push   $0x3fc
80107386:	e8 81 ff ff ff       	call   8010730c <outb>
8010738b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010738e:	6a 01                	push   $0x1
80107390:	68 f9 03 00 00       	push   $0x3f9
80107395:	e8 72 ff ff ff       	call   8010730c <outb>
8010739a:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010739d:	68 fd 03 00 00       	push   $0x3fd
801073a2:	e8 48 ff ff ff       	call   801072ef <inb>
801073a7:	83 c4 04             	add    $0x4,%esp
801073aa:	3c ff                	cmp    $0xff,%al
801073ac:	74 6e                	je     8010741c <uartinit+0xf1>
    return;
  uart = 1;
801073ae:	c7 05 a4 c7 10 80 01 	movl   $0x1,0x8010c7a4
801073b5:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801073b8:	68 fa 03 00 00       	push   $0x3fa
801073bd:	e8 2d ff ff ff       	call   801072ef <inb>
801073c2:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801073c5:	68 f8 03 00 00       	push   $0x3f8
801073ca:	e8 20 ff ff ff       	call   801072ef <inb>
801073cf:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801073d2:	83 ec 0c             	sub    $0xc,%esp
801073d5:	6a 04                	push   $0x4
801073d7:	e8 25 ce ff ff       	call   80104201 <picenable>
801073dc:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801073df:	83 ec 08             	sub    $0x8,%esp
801073e2:	6a 00                	push   $0x0
801073e4:	6a 04                	push   $0x4
801073e6:	e8 c5 b9 ff ff       	call   80102db0 <ioapicenable>
801073eb:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801073ee:	c7 45 f4 88 93 10 80 	movl   $0x80109388,-0xc(%ebp)
801073f5:	eb 19                	jmp    80107410 <uartinit+0xe5>
    uartputc(*p);
801073f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073fa:	0f b6 00             	movzbl (%eax),%eax
801073fd:	0f be c0             	movsbl %al,%eax
80107400:	83 ec 0c             	sub    $0xc,%esp
80107403:	50                   	push   %eax
80107404:	e8 16 00 00 00       	call   8010741f <uartputc>
80107409:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010740c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107413:	0f b6 00             	movzbl (%eax),%eax
80107416:	84 c0                	test   %al,%al
80107418:	75 dd                	jne    801073f7 <uartinit+0xcc>
8010741a:	eb 01                	jmp    8010741d <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010741c:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010741d:	c9                   	leave  
8010741e:	c3                   	ret    

8010741f <uartputc>:

void
uartputc(int c)
{
8010741f:	55                   	push   %ebp
80107420:	89 e5                	mov    %esp,%ebp
80107422:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107425:	a1 a4 c7 10 80       	mov    0x8010c7a4,%eax
8010742a:	85 c0                	test   %eax,%eax
8010742c:	74 53                	je     80107481 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010742e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107435:	eb 11                	jmp    80107448 <uartputc+0x29>
    microdelay(10);
80107437:	83 ec 0c             	sub    $0xc,%esp
8010743a:	6a 0a                	push   $0xa
8010743c:	e8 d5 be ff ff       	call   80103316 <microdelay>
80107441:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107444:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107448:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010744c:	7f 1a                	jg     80107468 <uartputc+0x49>
8010744e:	83 ec 0c             	sub    $0xc,%esp
80107451:	68 fd 03 00 00       	push   $0x3fd
80107456:	e8 94 fe ff ff       	call   801072ef <inb>
8010745b:	83 c4 10             	add    $0x10,%esp
8010745e:	0f b6 c0             	movzbl %al,%eax
80107461:	83 e0 20             	and    $0x20,%eax
80107464:	85 c0                	test   %eax,%eax
80107466:	74 cf                	je     80107437 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107468:	8b 45 08             	mov    0x8(%ebp),%eax
8010746b:	0f b6 c0             	movzbl %al,%eax
8010746e:	83 ec 08             	sub    $0x8,%esp
80107471:	50                   	push   %eax
80107472:	68 f8 03 00 00       	push   $0x3f8
80107477:	e8 90 fe ff ff       	call   8010730c <outb>
8010747c:	83 c4 10             	add    $0x10,%esp
8010747f:	eb 01                	jmp    80107482 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107481:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107482:	c9                   	leave  
80107483:	c3                   	ret    

80107484 <uartgetc>:

static int
uartgetc(void)
{
80107484:	55                   	push   %ebp
80107485:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107487:	a1 a4 c7 10 80       	mov    0x8010c7a4,%eax
8010748c:	85 c0                	test   %eax,%eax
8010748e:	75 07                	jne    80107497 <uartgetc+0x13>
    return -1;
80107490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107495:	eb 2e                	jmp    801074c5 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107497:	68 fd 03 00 00       	push   $0x3fd
8010749c:	e8 4e fe ff ff       	call   801072ef <inb>
801074a1:	83 c4 04             	add    $0x4,%esp
801074a4:	0f b6 c0             	movzbl %al,%eax
801074a7:	83 e0 01             	and    $0x1,%eax
801074aa:	85 c0                	test   %eax,%eax
801074ac:	75 07                	jne    801074b5 <uartgetc+0x31>
    return -1;
801074ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074b3:	eb 10                	jmp    801074c5 <uartgetc+0x41>
  return inb(COM1+0);
801074b5:	68 f8 03 00 00       	push   $0x3f8
801074ba:	e8 30 fe ff ff       	call   801072ef <inb>
801074bf:	83 c4 04             	add    $0x4,%esp
801074c2:	0f b6 c0             	movzbl %al,%eax
}
801074c5:	c9                   	leave  
801074c6:	c3                   	ret    

801074c7 <uartintr>:

void
uartintr(void)
{
801074c7:	55                   	push   %ebp
801074c8:	89 e5                	mov    %esp,%ebp
801074ca:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801074cd:	83 ec 0c             	sub    $0xc,%esp
801074d0:	68 84 74 10 80       	push   $0x80107484
801074d5:	e8 03 93 ff ff       	call   801007dd <consoleintr>
801074da:	83 c4 10             	add    $0x10,%esp
}
801074dd:	90                   	nop
801074de:	c9                   	leave  
801074df:	c3                   	ret    

801074e0 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $0
801074e2:	6a 00                	push   $0x0
  jmp alltraps
801074e4:	e9 a6 f9 ff ff       	jmp    80106e8f <alltraps>

801074e9 <vector1>:
.globl vector1
vector1:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $1
801074eb:	6a 01                	push   $0x1
  jmp alltraps
801074ed:	e9 9d f9 ff ff       	jmp    80106e8f <alltraps>

801074f2 <vector2>:
.globl vector2
vector2:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $2
801074f4:	6a 02                	push   $0x2
  jmp alltraps
801074f6:	e9 94 f9 ff ff       	jmp    80106e8f <alltraps>

801074fb <vector3>:
.globl vector3
vector3:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $3
801074fd:	6a 03                	push   $0x3
  jmp alltraps
801074ff:	e9 8b f9 ff ff       	jmp    80106e8f <alltraps>

80107504 <vector4>:
.globl vector4
vector4:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $4
80107506:	6a 04                	push   $0x4
  jmp alltraps
80107508:	e9 82 f9 ff ff       	jmp    80106e8f <alltraps>

8010750d <vector5>:
.globl vector5
vector5:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $5
8010750f:	6a 05                	push   $0x5
  jmp alltraps
80107511:	e9 79 f9 ff ff       	jmp    80106e8f <alltraps>

80107516 <vector6>:
.globl vector6
vector6:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $6
80107518:	6a 06                	push   $0x6
  jmp alltraps
8010751a:	e9 70 f9 ff ff       	jmp    80106e8f <alltraps>

8010751f <vector7>:
.globl vector7
vector7:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $7
80107521:	6a 07                	push   $0x7
  jmp alltraps
80107523:	e9 67 f9 ff ff       	jmp    80106e8f <alltraps>

80107528 <vector8>:
.globl vector8
vector8:
  pushl $8
80107528:	6a 08                	push   $0x8
  jmp alltraps
8010752a:	e9 60 f9 ff ff       	jmp    80106e8f <alltraps>

8010752f <vector9>:
.globl vector9
vector9:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $9
80107531:	6a 09                	push   $0x9
  jmp alltraps
80107533:	e9 57 f9 ff ff       	jmp    80106e8f <alltraps>

80107538 <vector10>:
.globl vector10
vector10:
  pushl $10
80107538:	6a 0a                	push   $0xa
  jmp alltraps
8010753a:	e9 50 f9 ff ff       	jmp    80106e8f <alltraps>

8010753f <vector11>:
.globl vector11
vector11:
  pushl $11
8010753f:	6a 0b                	push   $0xb
  jmp alltraps
80107541:	e9 49 f9 ff ff       	jmp    80106e8f <alltraps>

80107546 <vector12>:
.globl vector12
vector12:
  pushl $12
80107546:	6a 0c                	push   $0xc
  jmp alltraps
80107548:	e9 42 f9 ff ff       	jmp    80106e8f <alltraps>

8010754d <vector13>:
.globl vector13
vector13:
  pushl $13
8010754d:	6a 0d                	push   $0xd
  jmp alltraps
8010754f:	e9 3b f9 ff ff       	jmp    80106e8f <alltraps>

80107554 <vector14>:
.globl vector14
vector14:
  pushl $14
80107554:	6a 0e                	push   $0xe
  jmp alltraps
80107556:	e9 34 f9 ff ff       	jmp    80106e8f <alltraps>

8010755b <vector15>:
.globl vector15
vector15:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $15
8010755d:	6a 0f                	push   $0xf
  jmp alltraps
8010755f:	e9 2b f9 ff ff       	jmp    80106e8f <alltraps>

80107564 <vector16>:
.globl vector16
vector16:
  pushl $0
80107564:	6a 00                	push   $0x0
  pushl $16
80107566:	6a 10                	push   $0x10
  jmp alltraps
80107568:	e9 22 f9 ff ff       	jmp    80106e8f <alltraps>

8010756d <vector17>:
.globl vector17
vector17:
  pushl $17
8010756d:	6a 11                	push   $0x11
  jmp alltraps
8010756f:	e9 1b f9 ff ff       	jmp    80106e8f <alltraps>

80107574 <vector18>:
.globl vector18
vector18:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $18
80107576:	6a 12                	push   $0x12
  jmp alltraps
80107578:	e9 12 f9 ff ff       	jmp    80106e8f <alltraps>

8010757d <vector19>:
.globl vector19
vector19:
  pushl $0
8010757d:	6a 00                	push   $0x0
  pushl $19
8010757f:	6a 13                	push   $0x13
  jmp alltraps
80107581:	e9 09 f9 ff ff       	jmp    80106e8f <alltraps>

80107586 <vector20>:
.globl vector20
vector20:
  pushl $0
80107586:	6a 00                	push   $0x0
  pushl $20
80107588:	6a 14                	push   $0x14
  jmp alltraps
8010758a:	e9 00 f9 ff ff       	jmp    80106e8f <alltraps>

8010758f <vector21>:
.globl vector21
vector21:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $21
80107591:	6a 15                	push   $0x15
  jmp alltraps
80107593:	e9 f7 f8 ff ff       	jmp    80106e8f <alltraps>

80107598 <vector22>:
.globl vector22
vector22:
  pushl $0
80107598:	6a 00                	push   $0x0
  pushl $22
8010759a:	6a 16                	push   $0x16
  jmp alltraps
8010759c:	e9 ee f8 ff ff       	jmp    80106e8f <alltraps>

801075a1 <vector23>:
.globl vector23
vector23:
  pushl $0
801075a1:	6a 00                	push   $0x0
  pushl $23
801075a3:	6a 17                	push   $0x17
  jmp alltraps
801075a5:	e9 e5 f8 ff ff       	jmp    80106e8f <alltraps>

801075aa <vector24>:
.globl vector24
vector24:
  pushl $0
801075aa:	6a 00                	push   $0x0
  pushl $24
801075ac:	6a 18                	push   $0x18
  jmp alltraps
801075ae:	e9 dc f8 ff ff       	jmp    80106e8f <alltraps>

801075b3 <vector25>:
.globl vector25
vector25:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $25
801075b5:	6a 19                	push   $0x19
  jmp alltraps
801075b7:	e9 d3 f8 ff ff       	jmp    80106e8f <alltraps>

801075bc <vector26>:
.globl vector26
vector26:
  pushl $0
801075bc:	6a 00                	push   $0x0
  pushl $26
801075be:	6a 1a                	push   $0x1a
  jmp alltraps
801075c0:	e9 ca f8 ff ff       	jmp    80106e8f <alltraps>

801075c5 <vector27>:
.globl vector27
vector27:
  pushl $0
801075c5:	6a 00                	push   $0x0
  pushl $27
801075c7:	6a 1b                	push   $0x1b
  jmp alltraps
801075c9:	e9 c1 f8 ff ff       	jmp    80106e8f <alltraps>

801075ce <vector28>:
.globl vector28
vector28:
  pushl $0
801075ce:	6a 00                	push   $0x0
  pushl $28
801075d0:	6a 1c                	push   $0x1c
  jmp alltraps
801075d2:	e9 b8 f8 ff ff       	jmp    80106e8f <alltraps>

801075d7 <vector29>:
.globl vector29
vector29:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $29
801075d9:	6a 1d                	push   $0x1d
  jmp alltraps
801075db:	e9 af f8 ff ff       	jmp    80106e8f <alltraps>

801075e0 <vector30>:
.globl vector30
vector30:
  pushl $0
801075e0:	6a 00                	push   $0x0
  pushl $30
801075e2:	6a 1e                	push   $0x1e
  jmp alltraps
801075e4:	e9 a6 f8 ff ff       	jmp    80106e8f <alltraps>

801075e9 <vector31>:
.globl vector31
vector31:
  pushl $0
801075e9:	6a 00                	push   $0x0
  pushl $31
801075eb:	6a 1f                	push   $0x1f
  jmp alltraps
801075ed:	e9 9d f8 ff ff       	jmp    80106e8f <alltraps>

801075f2 <vector32>:
.globl vector32
vector32:
  pushl $0
801075f2:	6a 00                	push   $0x0
  pushl $32
801075f4:	6a 20                	push   $0x20
  jmp alltraps
801075f6:	e9 94 f8 ff ff       	jmp    80106e8f <alltraps>

801075fb <vector33>:
.globl vector33
vector33:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $33
801075fd:	6a 21                	push   $0x21
  jmp alltraps
801075ff:	e9 8b f8 ff ff       	jmp    80106e8f <alltraps>

80107604 <vector34>:
.globl vector34
vector34:
  pushl $0
80107604:	6a 00                	push   $0x0
  pushl $34
80107606:	6a 22                	push   $0x22
  jmp alltraps
80107608:	e9 82 f8 ff ff       	jmp    80106e8f <alltraps>

8010760d <vector35>:
.globl vector35
vector35:
  pushl $0
8010760d:	6a 00                	push   $0x0
  pushl $35
8010760f:	6a 23                	push   $0x23
  jmp alltraps
80107611:	e9 79 f8 ff ff       	jmp    80106e8f <alltraps>

80107616 <vector36>:
.globl vector36
vector36:
  pushl $0
80107616:	6a 00                	push   $0x0
  pushl $36
80107618:	6a 24                	push   $0x24
  jmp alltraps
8010761a:	e9 70 f8 ff ff       	jmp    80106e8f <alltraps>

8010761f <vector37>:
.globl vector37
vector37:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $37
80107621:	6a 25                	push   $0x25
  jmp alltraps
80107623:	e9 67 f8 ff ff       	jmp    80106e8f <alltraps>

80107628 <vector38>:
.globl vector38
vector38:
  pushl $0
80107628:	6a 00                	push   $0x0
  pushl $38
8010762a:	6a 26                	push   $0x26
  jmp alltraps
8010762c:	e9 5e f8 ff ff       	jmp    80106e8f <alltraps>

80107631 <vector39>:
.globl vector39
vector39:
  pushl $0
80107631:	6a 00                	push   $0x0
  pushl $39
80107633:	6a 27                	push   $0x27
  jmp alltraps
80107635:	e9 55 f8 ff ff       	jmp    80106e8f <alltraps>

8010763a <vector40>:
.globl vector40
vector40:
  pushl $0
8010763a:	6a 00                	push   $0x0
  pushl $40
8010763c:	6a 28                	push   $0x28
  jmp alltraps
8010763e:	e9 4c f8 ff ff       	jmp    80106e8f <alltraps>

80107643 <vector41>:
.globl vector41
vector41:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $41
80107645:	6a 29                	push   $0x29
  jmp alltraps
80107647:	e9 43 f8 ff ff       	jmp    80106e8f <alltraps>

8010764c <vector42>:
.globl vector42
vector42:
  pushl $0
8010764c:	6a 00                	push   $0x0
  pushl $42
8010764e:	6a 2a                	push   $0x2a
  jmp alltraps
80107650:	e9 3a f8 ff ff       	jmp    80106e8f <alltraps>

80107655 <vector43>:
.globl vector43
vector43:
  pushl $0
80107655:	6a 00                	push   $0x0
  pushl $43
80107657:	6a 2b                	push   $0x2b
  jmp alltraps
80107659:	e9 31 f8 ff ff       	jmp    80106e8f <alltraps>

8010765e <vector44>:
.globl vector44
vector44:
  pushl $0
8010765e:	6a 00                	push   $0x0
  pushl $44
80107660:	6a 2c                	push   $0x2c
  jmp alltraps
80107662:	e9 28 f8 ff ff       	jmp    80106e8f <alltraps>

80107667 <vector45>:
.globl vector45
vector45:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $45
80107669:	6a 2d                	push   $0x2d
  jmp alltraps
8010766b:	e9 1f f8 ff ff       	jmp    80106e8f <alltraps>

80107670 <vector46>:
.globl vector46
vector46:
  pushl $0
80107670:	6a 00                	push   $0x0
  pushl $46
80107672:	6a 2e                	push   $0x2e
  jmp alltraps
80107674:	e9 16 f8 ff ff       	jmp    80106e8f <alltraps>

80107679 <vector47>:
.globl vector47
vector47:
  pushl $0
80107679:	6a 00                	push   $0x0
  pushl $47
8010767b:	6a 2f                	push   $0x2f
  jmp alltraps
8010767d:	e9 0d f8 ff ff       	jmp    80106e8f <alltraps>

80107682 <vector48>:
.globl vector48
vector48:
  pushl $0
80107682:	6a 00                	push   $0x0
  pushl $48
80107684:	6a 30                	push   $0x30
  jmp alltraps
80107686:	e9 04 f8 ff ff       	jmp    80106e8f <alltraps>

8010768b <vector49>:
.globl vector49
vector49:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $49
8010768d:	6a 31                	push   $0x31
  jmp alltraps
8010768f:	e9 fb f7 ff ff       	jmp    80106e8f <alltraps>

80107694 <vector50>:
.globl vector50
vector50:
  pushl $0
80107694:	6a 00                	push   $0x0
  pushl $50
80107696:	6a 32                	push   $0x32
  jmp alltraps
80107698:	e9 f2 f7 ff ff       	jmp    80106e8f <alltraps>

8010769d <vector51>:
.globl vector51
vector51:
  pushl $0
8010769d:	6a 00                	push   $0x0
  pushl $51
8010769f:	6a 33                	push   $0x33
  jmp alltraps
801076a1:	e9 e9 f7 ff ff       	jmp    80106e8f <alltraps>

801076a6 <vector52>:
.globl vector52
vector52:
  pushl $0
801076a6:	6a 00                	push   $0x0
  pushl $52
801076a8:	6a 34                	push   $0x34
  jmp alltraps
801076aa:	e9 e0 f7 ff ff       	jmp    80106e8f <alltraps>

801076af <vector53>:
.globl vector53
vector53:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $53
801076b1:	6a 35                	push   $0x35
  jmp alltraps
801076b3:	e9 d7 f7 ff ff       	jmp    80106e8f <alltraps>

801076b8 <vector54>:
.globl vector54
vector54:
  pushl $0
801076b8:	6a 00                	push   $0x0
  pushl $54
801076ba:	6a 36                	push   $0x36
  jmp alltraps
801076bc:	e9 ce f7 ff ff       	jmp    80106e8f <alltraps>

801076c1 <vector55>:
.globl vector55
vector55:
  pushl $0
801076c1:	6a 00                	push   $0x0
  pushl $55
801076c3:	6a 37                	push   $0x37
  jmp alltraps
801076c5:	e9 c5 f7 ff ff       	jmp    80106e8f <alltraps>

801076ca <vector56>:
.globl vector56
vector56:
  pushl $0
801076ca:	6a 00                	push   $0x0
  pushl $56
801076cc:	6a 38                	push   $0x38
  jmp alltraps
801076ce:	e9 bc f7 ff ff       	jmp    80106e8f <alltraps>

801076d3 <vector57>:
.globl vector57
vector57:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $57
801076d5:	6a 39                	push   $0x39
  jmp alltraps
801076d7:	e9 b3 f7 ff ff       	jmp    80106e8f <alltraps>

801076dc <vector58>:
.globl vector58
vector58:
  pushl $0
801076dc:	6a 00                	push   $0x0
  pushl $58
801076de:	6a 3a                	push   $0x3a
  jmp alltraps
801076e0:	e9 aa f7 ff ff       	jmp    80106e8f <alltraps>

801076e5 <vector59>:
.globl vector59
vector59:
  pushl $0
801076e5:	6a 00                	push   $0x0
  pushl $59
801076e7:	6a 3b                	push   $0x3b
  jmp alltraps
801076e9:	e9 a1 f7 ff ff       	jmp    80106e8f <alltraps>

801076ee <vector60>:
.globl vector60
vector60:
  pushl $0
801076ee:	6a 00                	push   $0x0
  pushl $60
801076f0:	6a 3c                	push   $0x3c
  jmp alltraps
801076f2:	e9 98 f7 ff ff       	jmp    80106e8f <alltraps>

801076f7 <vector61>:
.globl vector61
vector61:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $61
801076f9:	6a 3d                	push   $0x3d
  jmp alltraps
801076fb:	e9 8f f7 ff ff       	jmp    80106e8f <alltraps>

80107700 <vector62>:
.globl vector62
vector62:
  pushl $0
80107700:	6a 00                	push   $0x0
  pushl $62
80107702:	6a 3e                	push   $0x3e
  jmp alltraps
80107704:	e9 86 f7 ff ff       	jmp    80106e8f <alltraps>

80107709 <vector63>:
.globl vector63
vector63:
  pushl $0
80107709:	6a 00                	push   $0x0
  pushl $63
8010770b:	6a 3f                	push   $0x3f
  jmp alltraps
8010770d:	e9 7d f7 ff ff       	jmp    80106e8f <alltraps>

80107712 <vector64>:
.globl vector64
vector64:
  pushl $0
80107712:	6a 00                	push   $0x0
  pushl $64
80107714:	6a 40                	push   $0x40
  jmp alltraps
80107716:	e9 74 f7 ff ff       	jmp    80106e8f <alltraps>

8010771b <vector65>:
.globl vector65
vector65:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $65
8010771d:	6a 41                	push   $0x41
  jmp alltraps
8010771f:	e9 6b f7 ff ff       	jmp    80106e8f <alltraps>

80107724 <vector66>:
.globl vector66
vector66:
  pushl $0
80107724:	6a 00                	push   $0x0
  pushl $66
80107726:	6a 42                	push   $0x42
  jmp alltraps
80107728:	e9 62 f7 ff ff       	jmp    80106e8f <alltraps>

8010772d <vector67>:
.globl vector67
vector67:
  pushl $0
8010772d:	6a 00                	push   $0x0
  pushl $67
8010772f:	6a 43                	push   $0x43
  jmp alltraps
80107731:	e9 59 f7 ff ff       	jmp    80106e8f <alltraps>

80107736 <vector68>:
.globl vector68
vector68:
  pushl $0
80107736:	6a 00                	push   $0x0
  pushl $68
80107738:	6a 44                	push   $0x44
  jmp alltraps
8010773a:	e9 50 f7 ff ff       	jmp    80106e8f <alltraps>

8010773f <vector69>:
.globl vector69
vector69:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $69
80107741:	6a 45                	push   $0x45
  jmp alltraps
80107743:	e9 47 f7 ff ff       	jmp    80106e8f <alltraps>

80107748 <vector70>:
.globl vector70
vector70:
  pushl $0
80107748:	6a 00                	push   $0x0
  pushl $70
8010774a:	6a 46                	push   $0x46
  jmp alltraps
8010774c:	e9 3e f7 ff ff       	jmp    80106e8f <alltraps>

80107751 <vector71>:
.globl vector71
vector71:
  pushl $0
80107751:	6a 00                	push   $0x0
  pushl $71
80107753:	6a 47                	push   $0x47
  jmp alltraps
80107755:	e9 35 f7 ff ff       	jmp    80106e8f <alltraps>

8010775a <vector72>:
.globl vector72
vector72:
  pushl $0
8010775a:	6a 00                	push   $0x0
  pushl $72
8010775c:	6a 48                	push   $0x48
  jmp alltraps
8010775e:	e9 2c f7 ff ff       	jmp    80106e8f <alltraps>

80107763 <vector73>:
.globl vector73
vector73:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $73
80107765:	6a 49                	push   $0x49
  jmp alltraps
80107767:	e9 23 f7 ff ff       	jmp    80106e8f <alltraps>

8010776c <vector74>:
.globl vector74
vector74:
  pushl $0
8010776c:	6a 00                	push   $0x0
  pushl $74
8010776e:	6a 4a                	push   $0x4a
  jmp alltraps
80107770:	e9 1a f7 ff ff       	jmp    80106e8f <alltraps>

80107775 <vector75>:
.globl vector75
vector75:
  pushl $0
80107775:	6a 00                	push   $0x0
  pushl $75
80107777:	6a 4b                	push   $0x4b
  jmp alltraps
80107779:	e9 11 f7 ff ff       	jmp    80106e8f <alltraps>

8010777e <vector76>:
.globl vector76
vector76:
  pushl $0
8010777e:	6a 00                	push   $0x0
  pushl $76
80107780:	6a 4c                	push   $0x4c
  jmp alltraps
80107782:	e9 08 f7 ff ff       	jmp    80106e8f <alltraps>

80107787 <vector77>:
.globl vector77
vector77:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $77
80107789:	6a 4d                	push   $0x4d
  jmp alltraps
8010778b:	e9 ff f6 ff ff       	jmp    80106e8f <alltraps>

80107790 <vector78>:
.globl vector78
vector78:
  pushl $0
80107790:	6a 00                	push   $0x0
  pushl $78
80107792:	6a 4e                	push   $0x4e
  jmp alltraps
80107794:	e9 f6 f6 ff ff       	jmp    80106e8f <alltraps>

80107799 <vector79>:
.globl vector79
vector79:
  pushl $0
80107799:	6a 00                	push   $0x0
  pushl $79
8010779b:	6a 4f                	push   $0x4f
  jmp alltraps
8010779d:	e9 ed f6 ff ff       	jmp    80106e8f <alltraps>

801077a2 <vector80>:
.globl vector80
vector80:
  pushl $0
801077a2:	6a 00                	push   $0x0
  pushl $80
801077a4:	6a 50                	push   $0x50
  jmp alltraps
801077a6:	e9 e4 f6 ff ff       	jmp    80106e8f <alltraps>

801077ab <vector81>:
.globl vector81
vector81:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $81
801077ad:	6a 51                	push   $0x51
  jmp alltraps
801077af:	e9 db f6 ff ff       	jmp    80106e8f <alltraps>

801077b4 <vector82>:
.globl vector82
vector82:
  pushl $0
801077b4:	6a 00                	push   $0x0
  pushl $82
801077b6:	6a 52                	push   $0x52
  jmp alltraps
801077b8:	e9 d2 f6 ff ff       	jmp    80106e8f <alltraps>

801077bd <vector83>:
.globl vector83
vector83:
  pushl $0
801077bd:	6a 00                	push   $0x0
  pushl $83
801077bf:	6a 53                	push   $0x53
  jmp alltraps
801077c1:	e9 c9 f6 ff ff       	jmp    80106e8f <alltraps>

801077c6 <vector84>:
.globl vector84
vector84:
  pushl $0
801077c6:	6a 00                	push   $0x0
  pushl $84
801077c8:	6a 54                	push   $0x54
  jmp alltraps
801077ca:	e9 c0 f6 ff ff       	jmp    80106e8f <alltraps>

801077cf <vector85>:
.globl vector85
vector85:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $85
801077d1:	6a 55                	push   $0x55
  jmp alltraps
801077d3:	e9 b7 f6 ff ff       	jmp    80106e8f <alltraps>

801077d8 <vector86>:
.globl vector86
vector86:
  pushl $0
801077d8:	6a 00                	push   $0x0
  pushl $86
801077da:	6a 56                	push   $0x56
  jmp alltraps
801077dc:	e9 ae f6 ff ff       	jmp    80106e8f <alltraps>

801077e1 <vector87>:
.globl vector87
vector87:
  pushl $0
801077e1:	6a 00                	push   $0x0
  pushl $87
801077e3:	6a 57                	push   $0x57
  jmp alltraps
801077e5:	e9 a5 f6 ff ff       	jmp    80106e8f <alltraps>

801077ea <vector88>:
.globl vector88
vector88:
  pushl $0
801077ea:	6a 00                	push   $0x0
  pushl $88
801077ec:	6a 58                	push   $0x58
  jmp alltraps
801077ee:	e9 9c f6 ff ff       	jmp    80106e8f <alltraps>

801077f3 <vector89>:
.globl vector89
vector89:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $89
801077f5:	6a 59                	push   $0x59
  jmp alltraps
801077f7:	e9 93 f6 ff ff       	jmp    80106e8f <alltraps>

801077fc <vector90>:
.globl vector90
vector90:
  pushl $0
801077fc:	6a 00                	push   $0x0
  pushl $90
801077fe:	6a 5a                	push   $0x5a
  jmp alltraps
80107800:	e9 8a f6 ff ff       	jmp    80106e8f <alltraps>

80107805 <vector91>:
.globl vector91
vector91:
  pushl $0
80107805:	6a 00                	push   $0x0
  pushl $91
80107807:	6a 5b                	push   $0x5b
  jmp alltraps
80107809:	e9 81 f6 ff ff       	jmp    80106e8f <alltraps>

8010780e <vector92>:
.globl vector92
vector92:
  pushl $0
8010780e:	6a 00                	push   $0x0
  pushl $92
80107810:	6a 5c                	push   $0x5c
  jmp alltraps
80107812:	e9 78 f6 ff ff       	jmp    80106e8f <alltraps>

80107817 <vector93>:
.globl vector93
vector93:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $93
80107819:	6a 5d                	push   $0x5d
  jmp alltraps
8010781b:	e9 6f f6 ff ff       	jmp    80106e8f <alltraps>

80107820 <vector94>:
.globl vector94
vector94:
  pushl $0
80107820:	6a 00                	push   $0x0
  pushl $94
80107822:	6a 5e                	push   $0x5e
  jmp alltraps
80107824:	e9 66 f6 ff ff       	jmp    80106e8f <alltraps>

80107829 <vector95>:
.globl vector95
vector95:
  pushl $0
80107829:	6a 00                	push   $0x0
  pushl $95
8010782b:	6a 5f                	push   $0x5f
  jmp alltraps
8010782d:	e9 5d f6 ff ff       	jmp    80106e8f <alltraps>

80107832 <vector96>:
.globl vector96
vector96:
  pushl $0
80107832:	6a 00                	push   $0x0
  pushl $96
80107834:	6a 60                	push   $0x60
  jmp alltraps
80107836:	e9 54 f6 ff ff       	jmp    80106e8f <alltraps>

8010783b <vector97>:
.globl vector97
vector97:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $97
8010783d:	6a 61                	push   $0x61
  jmp alltraps
8010783f:	e9 4b f6 ff ff       	jmp    80106e8f <alltraps>

80107844 <vector98>:
.globl vector98
vector98:
  pushl $0
80107844:	6a 00                	push   $0x0
  pushl $98
80107846:	6a 62                	push   $0x62
  jmp alltraps
80107848:	e9 42 f6 ff ff       	jmp    80106e8f <alltraps>

8010784d <vector99>:
.globl vector99
vector99:
  pushl $0
8010784d:	6a 00                	push   $0x0
  pushl $99
8010784f:	6a 63                	push   $0x63
  jmp alltraps
80107851:	e9 39 f6 ff ff       	jmp    80106e8f <alltraps>

80107856 <vector100>:
.globl vector100
vector100:
  pushl $0
80107856:	6a 00                	push   $0x0
  pushl $100
80107858:	6a 64                	push   $0x64
  jmp alltraps
8010785a:	e9 30 f6 ff ff       	jmp    80106e8f <alltraps>

8010785f <vector101>:
.globl vector101
vector101:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $101
80107861:	6a 65                	push   $0x65
  jmp alltraps
80107863:	e9 27 f6 ff ff       	jmp    80106e8f <alltraps>

80107868 <vector102>:
.globl vector102
vector102:
  pushl $0
80107868:	6a 00                	push   $0x0
  pushl $102
8010786a:	6a 66                	push   $0x66
  jmp alltraps
8010786c:	e9 1e f6 ff ff       	jmp    80106e8f <alltraps>

80107871 <vector103>:
.globl vector103
vector103:
  pushl $0
80107871:	6a 00                	push   $0x0
  pushl $103
80107873:	6a 67                	push   $0x67
  jmp alltraps
80107875:	e9 15 f6 ff ff       	jmp    80106e8f <alltraps>

8010787a <vector104>:
.globl vector104
vector104:
  pushl $0
8010787a:	6a 00                	push   $0x0
  pushl $104
8010787c:	6a 68                	push   $0x68
  jmp alltraps
8010787e:	e9 0c f6 ff ff       	jmp    80106e8f <alltraps>

80107883 <vector105>:
.globl vector105
vector105:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $105
80107885:	6a 69                	push   $0x69
  jmp alltraps
80107887:	e9 03 f6 ff ff       	jmp    80106e8f <alltraps>

8010788c <vector106>:
.globl vector106
vector106:
  pushl $0
8010788c:	6a 00                	push   $0x0
  pushl $106
8010788e:	6a 6a                	push   $0x6a
  jmp alltraps
80107890:	e9 fa f5 ff ff       	jmp    80106e8f <alltraps>

80107895 <vector107>:
.globl vector107
vector107:
  pushl $0
80107895:	6a 00                	push   $0x0
  pushl $107
80107897:	6a 6b                	push   $0x6b
  jmp alltraps
80107899:	e9 f1 f5 ff ff       	jmp    80106e8f <alltraps>

8010789e <vector108>:
.globl vector108
vector108:
  pushl $0
8010789e:	6a 00                	push   $0x0
  pushl $108
801078a0:	6a 6c                	push   $0x6c
  jmp alltraps
801078a2:	e9 e8 f5 ff ff       	jmp    80106e8f <alltraps>

801078a7 <vector109>:
.globl vector109
vector109:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $109
801078a9:	6a 6d                	push   $0x6d
  jmp alltraps
801078ab:	e9 df f5 ff ff       	jmp    80106e8f <alltraps>

801078b0 <vector110>:
.globl vector110
vector110:
  pushl $0
801078b0:	6a 00                	push   $0x0
  pushl $110
801078b2:	6a 6e                	push   $0x6e
  jmp alltraps
801078b4:	e9 d6 f5 ff ff       	jmp    80106e8f <alltraps>

801078b9 <vector111>:
.globl vector111
vector111:
  pushl $0
801078b9:	6a 00                	push   $0x0
  pushl $111
801078bb:	6a 6f                	push   $0x6f
  jmp alltraps
801078bd:	e9 cd f5 ff ff       	jmp    80106e8f <alltraps>

801078c2 <vector112>:
.globl vector112
vector112:
  pushl $0
801078c2:	6a 00                	push   $0x0
  pushl $112
801078c4:	6a 70                	push   $0x70
  jmp alltraps
801078c6:	e9 c4 f5 ff ff       	jmp    80106e8f <alltraps>

801078cb <vector113>:
.globl vector113
vector113:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $113
801078cd:	6a 71                	push   $0x71
  jmp alltraps
801078cf:	e9 bb f5 ff ff       	jmp    80106e8f <alltraps>

801078d4 <vector114>:
.globl vector114
vector114:
  pushl $0
801078d4:	6a 00                	push   $0x0
  pushl $114
801078d6:	6a 72                	push   $0x72
  jmp alltraps
801078d8:	e9 b2 f5 ff ff       	jmp    80106e8f <alltraps>

801078dd <vector115>:
.globl vector115
vector115:
  pushl $0
801078dd:	6a 00                	push   $0x0
  pushl $115
801078df:	6a 73                	push   $0x73
  jmp alltraps
801078e1:	e9 a9 f5 ff ff       	jmp    80106e8f <alltraps>

801078e6 <vector116>:
.globl vector116
vector116:
  pushl $0
801078e6:	6a 00                	push   $0x0
  pushl $116
801078e8:	6a 74                	push   $0x74
  jmp alltraps
801078ea:	e9 a0 f5 ff ff       	jmp    80106e8f <alltraps>

801078ef <vector117>:
.globl vector117
vector117:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $117
801078f1:	6a 75                	push   $0x75
  jmp alltraps
801078f3:	e9 97 f5 ff ff       	jmp    80106e8f <alltraps>

801078f8 <vector118>:
.globl vector118
vector118:
  pushl $0
801078f8:	6a 00                	push   $0x0
  pushl $118
801078fa:	6a 76                	push   $0x76
  jmp alltraps
801078fc:	e9 8e f5 ff ff       	jmp    80106e8f <alltraps>

80107901 <vector119>:
.globl vector119
vector119:
  pushl $0
80107901:	6a 00                	push   $0x0
  pushl $119
80107903:	6a 77                	push   $0x77
  jmp alltraps
80107905:	e9 85 f5 ff ff       	jmp    80106e8f <alltraps>

8010790a <vector120>:
.globl vector120
vector120:
  pushl $0
8010790a:	6a 00                	push   $0x0
  pushl $120
8010790c:	6a 78                	push   $0x78
  jmp alltraps
8010790e:	e9 7c f5 ff ff       	jmp    80106e8f <alltraps>

80107913 <vector121>:
.globl vector121
vector121:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $121
80107915:	6a 79                	push   $0x79
  jmp alltraps
80107917:	e9 73 f5 ff ff       	jmp    80106e8f <alltraps>

8010791c <vector122>:
.globl vector122
vector122:
  pushl $0
8010791c:	6a 00                	push   $0x0
  pushl $122
8010791e:	6a 7a                	push   $0x7a
  jmp alltraps
80107920:	e9 6a f5 ff ff       	jmp    80106e8f <alltraps>

80107925 <vector123>:
.globl vector123
vector123:
  pushl $0
80107925:	6a 00                	push   $0x0
  pushl $123
80107927:	6a 7b                	push   $0x7b
  jmp alltraps
80107929:	e9 61 f5 ff ff       	jmp    80106e8f <alltraps>

8010792e <vector124>:
.globl vector124
vector124:
  pushl $0
8010792e:	6a 00                	push   $0x0
  pushl $124
80107930:	6a 7c                	push   $0x7c
  jmp alltraps
80107932:	e9 58 f5 ff ff       	jmp    80106e8f <alltraps>

80107937 <vector125>:
.globl vector125
vector125:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $125
80107939:	6a 7d                	push   $0x7d
  jmp alltraps
8010793b:	e9 4f f5 ff ff       	jmp    80106e8f <alltraps>

80107940 <vector126>:
.globl vector126
vector126:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $126
80107942:	6a 7e                	push   $0x7e
  jmp alltraps
80107944:	e9 46 f5 ff ff       	jmp    80106e8f <alltraps>

80107949 <vector127>:
.globl vector127
vector127:
  pushl $0
80107949:	6a 00                	push   $0x0
  pushl $127
8010794b:	6a 7f                	push   $0x7f
  jmp alltraps
8010794d:	e9 3d f5 ff ff       	jmp    80106e8f <alltraps>

80107952 <vector128>:
.globl vector128
vector128:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $128
80107954:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107959:	e9 31 f5 ff ff       	jmp    80106e8f <alltraps>

8010795e <vector129>:
.globl vector129
vector129:
  pushl $0
8010795e:	6a 00                	push   $0x0
  pushl $129
80107960:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107965:	e9 25 f5 ff ff       	jmp    80106e8f <alltraps>

8010796a <vector130>:
.globl vector130
vector130:
  pushl $0
8010796a:	6a 00                	push   $0x0
  pushl $130
8010796c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107971:	e9 19 f5 ff ff       	jmp    80106e8f <alltraps>

80107976 <vector131>:
.globl vector131
vector131:
  pushl $0
80107976:	6a 00                	push   $0x0
  pushl $131
80107978:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010797d:	e9 0d f5 ff ff       	jmp    80106e8f <alltraps>

80107982 <vector132>:
.globl vector132
vector132:
  pushl $0
80107982:	6a 00                	push   $0x0
  pushl $132
80107984:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107989:	e9 01 f5 ff ff       	jmp    80106e8f <alltraps>

8010798e <vector133>:
.globl vector133
vector133:
  pushl $0
8010798e:	6a 00                	push   $0x0
  pushl $133
80107990:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107995:	e9 f5 f4 ff ff       	jmp    80106e8f <alltraps>

8010799a <vector134>:
.globl vector134
vector134:
  pushl $0
8010799a:	6a 00                	push   $0x0
  pushl $134
8010799c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801079a1:	e9 e9 f4 ff ff       	jmp    80106e8f <alltraps>

801079a6 <vector135>:
.globl vector135
vector135:
  pushl $0
801079a6:	6a 00                	push   $0x0
  pushl $135
801079a8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801079ad:	e9 dd f4 ff ff       	jmp    80106e8f <alltraps>

801079b2 <vector136>:
.globl vector136
vector136:
  pushl $0
801079b2:	6a 00                	push   $0x0
  pushl $136
801079b4:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801079b9:	e9 d1 f4 ff ff       	jmp    80106e8f <alltraps>

801079be <vector137>:
.globl vector137
vector137:
  pushl $0
801079be:	6a 00                	push   $0x0
  pushl $137
801079c0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801079c5:	e9 c5 f4 ff ff       	jmp    80106e8f <alltraps>

801079ca <vector138>:
.globl vector138
vector138:
  pushl $0
801079ca:	6a 00                	push   $0x0
  pushl $138
801079cc:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801079d1:	e9 b9 f4 ff ff       	jmp    80106e8f <alltraps>

801079d6 <vector139>:
.globl vector139
vector139:
  pushl $0
801079d6:	6a 00                	push   $0x0
  pushl $139
801079d8:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801079dd:	e9 ad f4 ff ff       	jmp    80106e8f <alltraps>

801079e2 <vector140>:
.globl vector140
vector140:
  pushl $0
801079e2:	6a 00                	push   $0x0
  pushl $140
801079e4:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801079e9:	e9 a1 f4 ff ff       	jmp    80106e8f <alltraps>

801079ee <vector141>:
.globl vector141
vector141:
  pushl $0
801079ee:	6a 00                	push   $0x0
  pushl $141
801079f0:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801079f5:	e9 95 f4 ff ff       	jmp    80106e8f <alltraps>

801079fa <vector142>:
.globl vector142
vector142:
  pushl $0
801079fa:	6a 00                	push   $0x0
  pushl $142
801079fc:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107a01:	e9 89 f4 ff ff       	jmp    80106e8f <alltraps>

80107a06 <vector143>:
.globl vector143
vector143:
  pushl $0
80107a06:	6a 00                	push   $0x0
  pushl $143
80107a08:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107a0d:	e9 7d f4 ff ff       	jmp    80106e8f <alltraps>

80107a12 <vector144>:
.globl vector144
vector144:
  pushl $0
80107a12:	6a 00                	push   $0x0
  pushl $144
80107a14:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107a19:	e9 71 f4 ff ff       	jmp    80106e8f <alltraps>

80107a1e <vector145>:
.globl vector145
vector145:
  pushl $0
80107a1e:	6a 00                	push   $0x0
  pushl $145
80107a20:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107a25:	e9 65 f4 ff ff       	jmp    80106e8f <alltraps>

80107a2a <vector146>:
.globl vector146
vector146:
  pushl $0
80107a2a:	6a 00                	push   $0x0
  pushl $146
80107a2c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107a31:	e9 59 f4 ff ff       	jmp    80106e8f <alltraps>

80107a36 <vector147>:
.globl vector147
vector147:
  pushl $0
80107a36:	6a 00                	push   $0x0
  pushl $147
80107a38:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107a3d:	e9 4d f4 ff ff       	jmp    80106e8f <alltraps>

80107a42 <vector148>:
.globl vector148
vector148:
  pushl $0
80107a42:	6a 00                	push   $0x0
  pushl $148
80107a44:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107a49:	e9 41 f4 ff ff       	jmp    80106e8f <alltraps>

80107a4e <vector149>:
.globl vector149
vector149:
  pushl $0
80107a4e:	6a 00                	push   $0x0
  pushl $149
80107a50:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107a55:	e9 35 f4 ff ff       	jmp    80106e8f <alltraps>

80107a5a <vector150>:
.globl vector150
vector150:
  pushl $0
80107a5a:	6a 00                	push   $0x0
  pushl $150
80107a5c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107a61:	e9 29 f4 ff ff       	jmp    80106e8f <alltraps>

80107a66 <vector151>:
.globl vector151
vector151:
  pushl $0
80107a66:	6a 00                	push   $0x0
  pushl $151
80107a68:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107a6d:	e9 1d f4 ff ff       	jmp    80106e8f <alltraps>

80107a72 <vector152>:
.globl vector152
vector152:
  pushl $0
80107a72:	6a 00                	push   $0x0
  pushl $152
80107a74:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107a79:	e9 11 f4 ff ff       	jmp    80106e8f <alltraps>

80107a7e <vector153>:
.globl vector153
vector153:
  pushl $0
80107a7e:	6a 00                	push   $0x0
  pushl $153
80107a80:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107a85:	e9 05 f4 ff ff       	jmp    80106e8f <alltraps>

80107a8a <vector154>:
.globl vector154
vector154:
  pushl $0
80107a8a:	6a 00                	push   $0x0
  pushl $154
80107a8c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107a91:	e9 f9 f3 ff ff       	jmp    80106e8f <alltraps>

80107a96 <vector155>:
.globl vector155
vector155:
  pushl $0
80107a96:	6a 00                	push   $0x0
  pushl $155
80107a98:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107a9d:	e9 ed f3 ff ff       	jmp    80106e8f <alltraps>

80107aa2 <vector156>:
.globl vector156
vector156:
  pushl $0
80107aa2:	6a 00                	push   $0x0
  pushl $156
80107aa4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107aa9:	e9 e1 f3 ff ff       	jmp    80106e8f <alltraps>

80107aae <vector157>:
.globl vector157
vector157:
  pushl $0
80107aae:	6a 00                	push   $0x0
  pushl $157
80107ab0:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107ab5:	e9 d5 f3 ff ff       	jmp    80106e8f <alltraps>

80107aba <vector158>:
.globl vector158
vector158:
  pushl $0
80107aba:	6a 00                	push   $0x0
  pushl $158
80107abc:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107ac1:	e9 c9 f3 ff ff       	jmp    80106e8f <alltraps>

80107ac6 <vector159>:
.globl vector159
vector159:
  pushl $0
80107ac6:	6a 00                	push   $0x0
  pushl $159
80107ac8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107acd:	e9 bd f3 ff ff       	jmp    80106e8f <alltraps>

80107ad2 <vector160>:
.globl vector160
vector160:
  pushl $0
80107ad2:	6a 00                	push   $0x0
  pushl $160
80107ad4:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107ad9:	e9 b1 f3 ff ff       	jmp    80106e8f <alltraps>

80107ade <vector161>:
.globl vector161
vector161:
  pushl $0
80107ade:	6a 00                	push   $0x0
  pushl $161
80107ae0:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107ae5:	e9 a5 f3 ff ff       	jmp    80106e8f <alltraps>

80107aea <vector162>:
.globl vector162
vector162:
  pushl $0
80107aea:	6a 00                	push   $0x0
  pushl $162
80107aec:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107af1:	e9 99 f3 ff ff       	jmp    80106e8f <alltraps>

80107af6 <vector163>:
.globl vector163
vector163:
  pushl $0
80107af6:	6a 00                	push   $0x0
  pushl $163
80107af8:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107afd:	e9 8d f3 ff ff       	jmp    80106e8f <alltraps>

80107b02 <vector164>:
.globl vector164
vector164:
  pushl $0
80107b02:	6a 00                	push   $0x0
  pushl $164
80107b04:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107b09:	e9 81 f3 ff ff       	jmp    80106e8f <alltraps>

80107b0e <vector165>:
.globl vector165
vector165:
  pushl $0
80107b0e:	6a 00                	push   $0x0
  pushl $165
80107b10:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107b15:	e9 75 f3 ff ff       	jmp    80106e8f <alltraps>

80107b1a <vector166>:
.globl vector166
vector166:
  pushl $0
80107b1a:	6a 00                	push   $0x0
  pushl $166
80107b1c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107b21:	e9 69 f3 ff ff       	jmp    80106e8f <alltraps>

80107b26 <vector167>:
.globl vector167
vector167:
  pushl $0
80107b26:	6a 00                	push   $0x0
  pushl $167
80107b28:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107b2d:	e9 5d f3 ff ff       	jmp    80106e8f <alltraps>

80107b32 <vector168>:
.globl vector168
vector168:
  pushl $0
80107b32:	6a 00                	push   $0x0
  pushl $168
80107b34:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107b39:	e9 51 f3 ff ff       	jmp    80106e8f <alltraps>

80107b3e <vector169>:
.globl vector169
vector169:
  pushl $0
80107b3e:	6a 00                	push   $0x0
  pushl $169
80107b40:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107b45:	e9 45 f3 ff ff       	jmp    80106e8f <alltraps>

80107b4a <vector170>:
.globl vector170
vector170:
  pushl $0
80107b4a:	6a 00                	push   $0x0
  pushl $170
80107b4c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107b51:	e9 39 f3 ff ff       	jmp    80106e8f <alltraps>

80107b56 <vector171>:
.globl vector171
vector171:
  pushl $0
80107b56:	6a 00                	push   $0x0
  pushl $171
80107b58:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107b5d:	e9 2d f3 ff ff       	jmp    80106e8f <alltraps>

80107b62 <vector172>:
.globl vector172
vector172:
  pushl $0
80107b62:	6a 00                	push   $0x0
  pushl $172
80107b64:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107b69:	e9 21 f3 ff ff       	jmp    80106e8f <alltraps>

80107b6e <vector173>:
.globl vector173
vector173:
  pushl $0
80107b6e:	6a 00                	push   $0x0
  pushl $173
80107b70:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107b75:	e9 15 f3 ff ff       	jmp    80106e8f <alltraps>

80107b7a <vector174>:
.globl vector174
vector174:
  pushl $0
80107b7a:	6a 00                	push   $0x0
  pushl $174
80107b7c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107b81:	e9 09 f3 ff ff       	jmp    80106e8f <alltraps>

80107b86 <vector175>:
.globl vector175
vector175:
  pushl $0
80107b86:	6a 00                	push   $0x0
  pushl $175
80107b88:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107b8d:	e9 fd f2 ff ff       	jmp    80106e8f <alltraps>

80107b92 <vector176>:
.globl vector176
vector176:
  pushl $0
80107b92:	6a 00                	push   $0x0
  pushl $176
80107b94:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107b99:	e9 f1 f2 ff ff       	jmp    80106e8f <alltraps>

80107b9e <vector177>:
.globl vector177
vector177:
  pushl $0
80107b9e:	6a 00                	push   $0x0
  pushl $177
80107ba0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107ba5:	e9 e5 f2 ff ff       	jmp    80106e8f <alltraps>

80107baa <vector178>:
.globl vector178
vector178:
  pushl $0
80107baa:	6a 00                	push   $0x0
  pushl $178
80107bac:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107bb1:	e9 d9 f2 ff ff       	jmp    80106e8f <alltraps>

80107bb6 <vector179>:
.globl vector179
vector179:
  pushl $0
80107bb6:	6a 00                	push   $0x0
  pushl $179
80107bb8:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107bbd:	e9 cd f2 ff ff       	jmp    80106e8f <alltraps>

80107bc2 <vector180>:
.globl vector180
vector180:
  pushl $0
80107bc2:	6a 00                	push   $0x0
  pushl $180
80107bc4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107bc9:	e9 c1 f2 ff ff       	jmp    80106e8f <alltraps>

80107bce <vector181>:
.globl vector181
vector181:
  pushl $0
80107bce:	6a 00                	push   $0x0
  pushl $181
80107bd0:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107bd5:	e9 b5 f2 ff ff       	jmp    80106e8f <alltraps>

80107bda <vector182>:
.globl vector182
vector182:
  pushl $0
80107bda:	6a 00                	push   $0x0
  pushl $182
80107bdc:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107be1:	e9 a9 f2 ff ff       	jmp    80106e8f <alltraps>

80107be6 <vector183>:
.globl vector183
vector183:
  pushl $0
80107be6:	6a 00                	push   $0x0
  pushl $183
80107be8:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107bed:	e9 9d f2 ff ff       	jmp    80106e8f <alltraps>

80107bf2 <vector184>:
.globl vector184
vector184:
  pushl $0
80107bf2:	6a 00                	push   $0x0
  pushl $184
80107bf4:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107bf9:	e9 91 f2 ff ff       	jmp    80106e8f <alltraps>

80107bfe <vector185>:
.globl vector185
vector185:
  pushl $0
80107bfe:	6a 00                	push   $0x0
  pushl $185
80107c00:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107c05:	e9 85 f2 ff ff       	jmp    80106e8f <alltraps>

80107c0a <vector186>:
.globl vector186
vector186:
  pushl $0
80107c0a:	6a 00                	push   $0x0
  pushl $186
80107c0c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107c11:	e9 79 f2 ff ff       	jmp    80106e8f <alltraps>

80107c16 <vector187>:
.globl vector187
vector187:
  pushl $0
80107c16:	6a 00                	push   $0x0
  pushl $187
80107c18:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107c1d:	e9 6d f2 ff ff       	jmp    80106e8f <alltraps>

80107c22 <vector188>:
.globl vector188
vector188:
  pushl $0
80107c22:	6a 00                	push   $0x0
  pushl $188
80107c24:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107c29:	e9 61 f2 ff ff       	jmp    80106e8f <alltraps>

80107c2e <vector189>:
.globl vector189
vector189:
  pushl $0
80107c2e:	6a 00                	push   $0x0
  pushl $189
80107c30:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107c35:	e9 55 f2 ff ff       	jmp    80106e8f <alltraps>

80107c3a <vector190>:
.globl vector190
vector190:
  pushl $0
80107c3a:	6a 00                	push   $0x0
  pushl $190
80107c3c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107c41:	e9 49 f2 ff ff       	jmp    80106e8f <alltraps>

80107c46 <vector191>:
.globl vector191
vector191:
  pushl $0
80107c46:	6a 00                	push   $0x0
  pushl $191
80107c48:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107c4d:	e9 3d f2 ff ff       	jmp    80106e8f <alltraps>

80107c52 <vector192>:
.globl vector192
vector192:
  pushl $0
80107c52:	6a 00                	push   $0x0
  pushl $192
80107c54:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107c59:	e9 31 f2 ff ff       	jmp    80106e8f <alltraps>

80107c5e <vector193>:
.globl vector193
vector193:
  pushl $0
80107c5e:	6a 00                	push   $0x0
  pushl $193
80107c60:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107c65:	e9 25 f2 ff ff       	jmp    80106e8f <alltraps>

80107c6a <vector194>:
.globl vector194
vector194:
  pushl $0
80107c6a:	6a 00                	push   $0x0
  pushl $194
80107c6c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107c71:	e9 19 f2 ff ff       	jmp    80106e8f <alltraps>

80107c76 <vector195>:
.globl vector195
vector195:
  pushl $0
80107c76:	6a 00                	push   $0x0
  pushl $195
80107c78:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107c7d:	e9 0d f2 ff ff       	jmp    80106e8f <alltraps>

80107c82 <vector196>:
.globl vector196
vector196:
  pushl $0
80107c82:	6a 00                	push   $0x0
  pushl $196
80107c84:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107c89:	e9 01 f2 ff ff       	jmp    80106e8f <alltraps>

80107c8e <vector197>:
.globl vector197
vector197:
  pushl $0
80107c8e:	6a 00                	push   $0x0
  pushl $197
80107c90:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107c95:	e9 f5 f1 ff ff       	jmp    80106e8f <alltraps>

80107c9a <vector198>:
.globl vector198
vector198:
  pushl $0
80107c9a:	6a 00                	push   $0x0
  pushl $198
80107c9c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107ca1:	e9 e9 f1 ff ff       	jmp    80106e8f <alltraps>

80107ca6 <vector199>:
.globl vector199
vector199:
  pushl $0
80107ca6:	6a 00                	push   $0x0
  pushl $199
80107ca8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107cad:	e9 dd f1 ff ff       	jmp    80106e8f <alltraps>

80107cb2 <vector200>:
.globl vector200
vector200:
  pushl $0
80107cb2:	6a 00                	push   $0x0
  pushl $200
80107cb4:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107cb9:	e9 d1 f1 ff ff       	jmp    80106e8f <alltraps>

80107cbe <vector201>:
.globl vector201
vector201:
  pushl $0
80107cbe:	6a 00                	push   $0x0
  pushl $201
80107cc0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107cc5:	e9 c5 f1 ff ff       	jmp    80106e8f <alltraps>

80107cca <vector202>:
.globl vector202
vector202:
  pushl $0
80107cca:	6a 00                	push   $0x0
  pushl $202
80107ccc:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107cd1:	e9 b9 f1 ff ff       	jmp    80106e8f <alltraps>

80107cd6 <vector203>:
.globl vector203
vector203:
  pushl $0
80107cd6:	6a 00                	push   $0x0
  pushl $203
80107cd8:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107cdd:	e9 ad f1 ff ff       	jmp    80106e8f <alltraps>

80107ce2 <vector204>:
.globl vector204
vector204:
  pushl $0
80107ce2:	6a 00                	push   $0x0
  pushl $204
80107ce4:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107ce9:	e9 a1 f1 ff ff       	jmp    80106e8f <alltraps>

80107cee <vector205>:
.globl vector205
vector205:
  pushl $0
80107cee:	6a 00                	push   $0x0
  pushl $205
80107cf0:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107cf5:	e9 95 f1 ff ff       	jmp    80106e8f <alltraps>

80107cfa <vector206>:
.globl vector206
vector206:
  pushl $0
80107cfa:	6a 00                	push   $0x0
  pushl $206
80107cfc:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107d01:	e9 89 f1 ff ff       	jmp    80106e8f <alltraps>

80107d06 <vector207>:
.globl vector207
vector207:
  pushl $0
80107d06:	6a 00                	push   $0x0
  pushl $207
80107d08:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107d0d:	e9 7d f1 ff ff       	jmp    80106e8f <alltraps>

80107d12 <vector208>:
.globl vector208
vector208:
  pushl $0
80107d12:	6a 00                	push   $0x0
  pushl $208
80107d14:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107d19:	e9 71 f1 ff ff       	jmp    80106e8f <alltraps>

80107d1e <vector209>:
.globl vector209
vector209:
  pushl $0
80107d1e:	6a 00                	push   $0x0
  pushl $209
80107d20:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107d25:	e9 65 f1 ff ff       	jmp    80106e8f <alltraps>

80107d2a <vector210>:
.globl vector210
vector210:
  pushl $0
80107d2a:	6a 00                	push   $0x0
  pushl $210
80107d2c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107d31:	e9 59 f1 ff ff       	jmp    80106e8f <alltraps>

80107d36 <vector211>:
.globl vector211
vector211:
  pushl $0
80107d36:	6a 00                	push   $0x0
  pushl $211
80107d38:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107d3d:	e9 4d f1 ff ff       	jmp    80106e8f <alltraps>

80107d42 <vector212>:
.globl vector212
vector212:
  pushl $0
80107d42:	6a 00                	push   $0x0
  pushl $212
80107d44:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107d49:	e9 41 f1 ff ff       	jmp    80106e8f <alltraps>

80107d4e <vector213>:
.globl vector213
vector213:
  pushl $0
80107d4e:	6a 00                	push   $0x0
  pushl $213
80107d50:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107d55:	e9 35 f1 ff ff       	jmp    80106e8f <alltraps>

80107d5a <vector214>:
.globl vector214
vector214:
  pushl $0
80107d5a:	6a 00                	push   $0x0
  pushl $214
80107d5c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107d61:	e9 29 f1 ff ff       	jmp    80106e8f <alltraps>

80107d66 <vector215>:
.globl vector215
vector215:
  pushl $0
80107d66:	6a 00                	push   $0x0
  pushl $215
80107d68:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107d6d:	e9 1d f1 ff ff       	jmp    80106e8f <alltraps>

80107d72 <vector216>:
.globl vector216
vector216:
  pushl $0
80107d72:	6a 00                	push   $0x0
  pushl $216
80107d74:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107d79:	e9 11 f1 ff ff       	jmp    80106e8f <alltraps>

80107d7e <vector217>:
.globl vector217
vector217:
  pushl $0
80107d7e:	6a 00                	push   $0x0
  pushl $217
80107d80:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107d85:	e9 05 f1 ff ff       	jmp    80106e8f <alltraps>

80107d8a <vector218>:
.globl vector218
vector218:
  pushl $0
80107d8a:	6a 00                	push   $0x0
  pushl $218
80107d8c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107d91:	e9 f9 f0 ff ff       	jmp    80106e8f <alltraps>

80107d96 <vector219>:
.globl vector219
vector219:
  pushl $0
80107d96:	6a 00                	push   $0x0
  pushl $219
80107d98:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107d9d:	e9 ed f0 ff ff       	jmp    80106e8f <alltraps>

80107da2 <vector220>:
.globl vector220
vector220:
  pushl $0
80107da2:	6a 00                	push   $0x0
  pushl $220
80107da4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107da9:	e9 e1 f0 ff ff       	jmp    80106e8f <alltraps>

80107dae <vector221>:
.globl vector221
vector221:
  pushl $0
80107dae:	6a 00                	push   $0x0
  pushl $221
80107db0:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107db5:	e9 d5 f0 ff ff       	jmp    80106e8f <alltraps>

80107dba <vector222>:
.globl vector222
vector222:
  pushl $0
80107dba:	6a 00                	push   $0x0
  pushl $222
80107dbc:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107dc1:	e9 c9 f0 ff ff       	jmp    80106e8f <alltraps>

80107dc6 <vector223>:
.globl vector223
vector223:
  pushl $0
80107dc6:	6a 00                	push   $0x0
  pushl $223
80107dc8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107dcd:	e9 bd f0 ff ff       	jmp    80106e8f <alltraps>

80107dd2 <vector224>:
.globl vector224
vector224:
  pushl $0
80107dd2:	6a 00                	push   $0x0
  pushl $224
80107dd4:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107dd9:	e9 b1 f0 ff ff       	jmp    80106e8f <alltraps>

80107dde <vector225>:
.globl vector225
vector225:
  pushl $0
80107dde:	6a 00                	push   $0x0
  pushl $225
80107de0:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107de5:	e9 a5 f0 ff ff       	jmp    80106e8f <alltraps>

80107dea <vector226>:
.globl vector226
vector226:
  pushl $0
80107dea:	6a 00                	push   $0x0
  pushl $226
80107dec:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107df1:	e9 99 f0 ff ff       	jmp    80106e8f <alltraps>

80107df6 <vector227>:
.globl vector227
vector227:
  pushl $0
80107df6:	6a 00                	push   $0x0
  pushl $227
80107df8:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107dfd:	e9 8d f0 ff ff       	jmp    80106e8f <alltraps>

80107e02 <vector228>:
.globl vector228
vector228:
  pushl $0
80107e02:	6a 00                	push   $0x0
  pushl $228
80107e04:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107e09:	e9 81 f0 ff ff       	jmp    80106e8f <alltraps>

80107e0e <vector229>:
.globl vector229
vector229:
  pushl $0
80107e0e:	6a 00                	push   $0x0
  pushl $229
80107e10:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107e15:	e9 75 f0 ff ff       	jmp    80106e8f <alltraps>

80107e1a <vector230>:
.globl vector230
vector230:
  pushl $0
80107e1a:	6a 00                	push   $0x0
  pushl $230
80107e1c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107e21:	e9 69 f0 ff ff       	jmp    80106e8f <alltraps>

80107e26 <vector231>:
.globl vector231
vector231:
  pushl $0
80107e26:	6a 00                	push   $0x0
  pushl $231
80107e28:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107e2d:	e9 5d f0 ff ff       	jmp    80106e8f <alltraps>

80107e32 <vector232>:
.globl vector232
vector232:
  pushl $0
80107e32:	6a 00                	push   $0x0
  pushl $232
80107e34:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107e39:	e9 51 f0 ff ff       	jmp    80106e8f <alltraps>

80107e3e <vector233>:
.globl vector233
vector233:
  pushl $0
80107e3e:	6a 00                	push   $0x0
  pushl $233
80107e40:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107e45:	e9 45 f0 ff ff       	jmp    80106e8f <alltraps>

80107e4a <vector234>:
.globl vector234
vector234:
  pushl $0
80107e4a:	6a 00                	push   $0x0
  pushl $234
80107e4c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107e51:	e9 39 f0 ff ff       	jmp    80106e8f <alltraps>

80107e56 <vector235>:
.globl vector235
vector235:
  pushl $0
80107e56:	6a 00                	push   $0x0
  pushl $235
80107e58:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107e5d:	e9 2d f0 ff ff       	jmp    80106e8f <alltraps>

80107e62 <vector236>:
.globl vector236
vector236:
  pushl $0
80107e62:	6a 00                	push   $0x0
  pushl $236
80107e64:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107e69:	e9 21 f0 ff ff       	jmp    80106e8f <alltraps>

80107e6e <vector237>:
.globl vector237
vector237:
  pushl $0
80107e6e:	6a 00                	push   $0x0
  pushl $237
80107e70:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107e75:	e9 15 f0 ff ff       	jmp    80106e8f <alltraps>

80107e7a <vector238>:
.globl vector238
vector238:
  pushl $0
80107e7a:	6a 00                	push   $0x0
  pushl $238
80107e7c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107e81:	e9 09 f0 ff ff       	jmp    80106e8f <alltraps>

80107e86 <vector239>:
.globl vector239
vector239:
  pushl $0
80107e86:	6a 00                	push   $0x0
  pushl $239
80107e88:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107e8d:	e9 fd ef ff ff       	jmp    80106e8f <alltraps>

80107e92 <vector240>:
.globl vector240
vector240:
  pushl $0
80107e92:	6a 00                	push   $0x0
  pushl $240
80107e94:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107e99:	e9 f1 ef ff ff       	jmp    80106e8f <alltraps>

80107e9e <vector241>:
.globl vector241
vector241:
  pushl $0
80107e9e:	6a 00                	push   $0x0
  pushl $241
80107ea0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107ea5:	e9 e5 ef ff ff       	jmp    80106e8f <alltraps>

80107eaa <vector242>:
.globl vector242
vector242:
  pushl $0
80107eaa:	6a 00                	push   $0x0
  pushl $242
80107eac:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107eb1:	e9 d9 ef ff ff       	jmp    80106e8f <alltraps>

80107eb6 <vector243>:
.globl vector243
vector243:
  pushl $0
80107eb6:	6a 00                	push   $0x0
  pushl $243
80107eb8:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107ebd:	e9 cd ef ff ff       	jmp    80106e8f <alltraps>

80107ec2 <vector244>:
.globl vector244
vector244:
  pushl $0
80107ec2:	6a 00                	push   $0x0
  pushl $244
80107ec4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ec9:	e9 c1 ef ff ff       	jmp    80106e8f <alltraps>

80107ece <vector245>:
.globl vector245
vector245:
  pushl $0
80107ece:	6a 00                	push   $0x0
  pushl $245
80107ed0:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107ed5:	e9 b5 ef ff ff       	jmp    80106e8f <alltraps>

80107eda <vector246>:
.globl vector246
vector246:
  pushl $0
80107eda:	6a 00                	push   $0x0
  pushl $246
80107edc:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107ee1:	e9 a9 ef ff ff       	jmp    80106e8f <alltraps>

80107ee6 <vector247>:
.globl vector247
vector247:
  pushl $0
80107ee6:	6a 00                	push   $0x0
  pushl $247
80107ee8:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107eed:	e9 9d ef ff ff       	jmp    80106e8f <alltraps>

80107ef2 <vector248>:
.globl vector248
vector248:
  pushl $0
80107ef2:	6a 00                	push   $0x0
  pushl $248
80107ef4:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107ef9:	e9 91 ef ff ff       	jmp    80106e8f <alltraps>

80107efe <vector249>:
.globl vector249
vector249:
  pushl $0
80107efe:	6a 00                	push   $0x0
  pushl $249
80107f00:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107f05:	e9 85 ef ff ff       	jmp    80106e8f <alltraps>

80107f0a <vector250>:
.globl vector250
vector250:
  pushl $0
80107f0a:	6a 00                	push   $0x0
  pushl $250
80107f0c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107f11:	e9 79 ef ff ff       	jmp    80106e8f <alltraps>

80107f16 <vector251>:
.globl vector251
vector251:
  pushl $0
80107f16:	6a 00                	push   $0x0
  pushl $251
80107f18:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107f1d:	e9 6d ef ff ff       	jmp    80106e8f <alltraps>

80107f22 <vector252>:
.globl vector252
vector252:
  pushl $0
80107f22:	6a 00                	push   $0x0
  pushl $252
80107f24:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107f29:	e9 61 ef ff ff       	jmp    80106e8f <alltraps>

80107f2e <vector253>:
.globl vector253
vector253:
  pushl $0
80107f2e:	6a 00                	push   $0x0
  pushl $253
80107f30:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107f35:	e9 55 ef ff ff       	jmp    80106e8f <alltraps>

80107f3a <vector254>:
.globl vector254
vector254:
  pushl $0
80107f3a:	6a 00                	push   $0x0
  pushl $254
80107f3c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107f41:	e9 49 ef ff ff       	jmp    80106e8f <alltraps>

80107f46 <vector255>:
.globl vector255
vector255:
  pushl $0
80107f46:	6a 00                	push   $0x0
  pushl $255
80107f48:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107f4d:	e9 3d ef ff ff       	jmp    80106e8f <alltraps>

80107f52 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107f52:	55                   	push   %ebp
80107f53:	89 e5                	mov    %esp,%ebp
80107f55:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107f58:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f5b:	83 e8 01             	sub    $0x1,%eax
80107f5e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107f62:	8b 45 08             	mov    0x8(%ebp),%eax
80107f65:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107f69:	8b 45 08             	mov    0x8(%ebp),%eax
80107f6c:	c1 e8 10             	shr    $0x10,%eax
80107f6f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107f73:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107f76:	0f 01 10             	lgdtl  (%eax)
}
80107f79:	90                   	nop
80107f7a:	c9                   	leave  
80107f7b:	c3                   	ret    

80107f7c <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107f7c:	55                   	push   %ebp
80107f7d:	89 e5                	mov    %esp,%ebp
80107f7f:	83 ec 04             	sub    $0x4,%esp
80107f82:	8b 45 08             	mov    0x8(%ebp),%eax
80107f85:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107f89:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107f8d:	0f 00 d8             	ltr    %ax
}
80107f90:	90                   	nop
80107f91:	c9                   	leave  
80107f92:	c3                   	ret    

80107f93 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107f93:	55                   	push   %ebp
80107f94:	89 e5                	mov    %esp,%ebp
80107f96:	83 ec 04             	sub    $0x4,%esp
80107f99:	8b 45 08             	mov    0x8(%ebp),%eax
80107f9c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107fa0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107fa4:	8e e8                	mov    %eax,%gs
}
80107fa6:	90                   	nop
80107fa7:	c9                   	leave  
80107fa8:	c3                   	ret    

80107fa9 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107fa9:	55                   	push   %ebp
80107faa:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107fac:	8b 45 08             	mov    0x8(%ebp),%eax
80107faf:	0f 22 d8             	mov    %eax,%cr3
}
80107fb2:	90                   	nop
80107fb3:	5d                   	pop    %ebp
80107fb4:	c3                   	ret    

80107fb5 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107fb5:	55                   	push   %ebp
80107fb6:	89 e5                	mov    %esp,%ebp
80107fb8:	8b 45 08             	mov    0x8(%ebp),%eax
80107fbb:	05 00 00 00 80       	add    $0x80000000,%eax
80107fc0:	5d                   	pop    %ebp
80107fc1:	c3                   	ret    

80107fc2 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107fc2:	55                   	push   %ebp
80107fc3:	89 e5                	mov    %esp,%ebp
80107fc5:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc8:	05 00 00 00 80       	add    $0x80000000,%eax
80107fcd:	5d                   	pop    %ebp
80107fce:	c3                   	ret    

80107fcf <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107fcf:	55                   	push   %ebp
80107fd0:	89 e5                	mov    %esp,%ebp
80107fd2:	53                   	push   %ebx
80107fd3:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107fd6:	e8 c7 b2 ff ff       	call   801032a2 <cpunum>
80107fdb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107fe1:	05 80 36 11 80       	add    $0x80113680,%eax
80107fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fec:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff5:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffe:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108002:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108005:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108009:	83 e2 f0             	and    $0xfffffff0,%edx
8010800c:	83 ca 0a             	or     $0xa,%edx
8010800f:	88 50 7d             	mov    %dl,0x7d(%eax)
80108012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108015:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108019:	83 ca 10             	or     $0x10,%edx
8010801c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010801f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108022:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108026:	83 e2 9f             	and    $0xffffff9f,%edx
80108029:	88 50 7d             	mov    %dl,0x7d(%eax)
8010802c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108033:	83 ca 80             	or     $0xffffff80,%edx
80108036:	88 50 7d             	mov    %dl,0x7d(%eax)
80108039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108040:	83 ca 0f             	or     $0xf,%edx
80108043:	88 50 7e             	mov    %dl,0x7e(%eax)
80108046:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108049:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010804d:	83 e2 ef             	and    $0xffffffef,%edx
80108050:	88 50 7e             	mov    %dl,0x7e(%eax)
80108053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108056:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010805a:	83 e2 df             	and    $0xffffffdf,%edx
8010805d:	88 50 7e             	mov    %dl,0x7e(%eax)
80108060:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108063:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108067:	83 ca 40             	or     $0x40,%edx
8010806a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010806d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108070:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108074:	83 ca 80             	or     $0xffffff80,%edx
80108077:	88 50 7e             	mov    %dl,0x7e(%eax)
8010807a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807d:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108084:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010808b:	ff ff 
8010808d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108090:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108097:	00 00 
80108099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809c:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801080a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080ad:	83 e2 f0             	and    $0xfffffff0,%edx
801080b0:	83 ca 02             	or     $0x2,%edx
801080b3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bc:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080c3:	83 ca 10             	or     $0x10,%edx
801080c6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cf:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080d6:	83 e2 9f             	and    $0xffffff9f,%edx
801080d9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080e9:	83 ca 80             	or     $0xffffff80,%edx
801080ec:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801080fc:	83 ca 0f             	or     $0xf,%edx
801080ff:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108108:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010810f:	83 e2 ef             	and    $0xffffffef,%edx
80108112:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108122:	83 e2 df             	and    $0xffffffdf,%edx
80108125:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010812b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108135:	83 ca 40             	or     $0x40,%edx
80108138:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010813e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108141:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108148:	83 ca 80             	or     $0xffffff80,%edx
8010814b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108154:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010815b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108165:	ff ff 
80108167:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816a:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108171:	00 00 
80108173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108176:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010817d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108180:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108187:	83 e2 f0             	and    $0xfffffff0,%edx
8010818a:	83 ca 0a             	or     $0xa,%edx
8010818d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108196:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010819d:	83 ca 10             	or     $0x10,%edx
801081a0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081b0:	83 ca 60             	or     $0x60,%edx
801081b3:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081bc:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081c3:	83 ca 80             	or     $0xffffff80,%edx
801081c6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cf:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081d6:	83 ca 0f             	or     $0xf,%edx
801081d9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081e9:	83 e2 ef             	and    $0xffffffef,%edx
801081ec:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081fc:	83 e2 df             	and    $0xffffffdf,%edx
801081ff:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108208:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010820f:	83 ca 40             	or     $0x40,%edx
80108212:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108218:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010821b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108222:	83 ca 80             	or     $0xffffff80,%edx
80108225:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010822b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822e:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108238:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010823f:	ff ff 
80108241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108244:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010824b:	00 00 
8010824d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108250:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108261:	83 e2 f0             	and    $0xfffffff0,%edx
80108264:	83 ca 02             	or     $0x2,%edx
80108267:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010826d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108270:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108277:	83 ca 10             	or     $0x10,%edx
8010827a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108283:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010828a:	83 ca 60             	or     $0x60,%edx
8010828d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108296:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010829d:	83 ca 80             	or     $0xffffff80,%edx
801082a0:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a9:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082b0:	83 ca 0f             	or     $0xf,%edx
801082b3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082bc:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082c3:	83 e2 ef             	and    $0xffffffef,%edx
801082c6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082cf:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082d6:	83 e2 df             	and    $0xffffffdf,%edx
801082d9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082e9:	83 ca 40             	or     $0x40,%edx
801082ec:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082fc:	83 ca 80             	or     $0xffffff80,%edx
801082ff:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108308:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010830f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108312:	05 b4 00 00 00       	add    $0xb4,%eax
80108317:	89 c3                	mov    %eax,%ebx
80108319:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010831c:	05 b4 00 00 00       	add    $0xb4,%eax
80108321:	c1 e8 10             	shr    $0x10,%eax
80108324:	89 c2                	mov    %eax,%edx
80108326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108329:	05 b4 00 00 00       	add    $0xb4,%eax
8010832e:	c1 e8 18             	shr    $0x18,%eax
80108331:	89 c1                	mov    %eax,%ecx
80108333:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108336:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010833d:	00 00 
8010833f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108342:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834c:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108355:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010835c:	83 e2 f0             	and    $0xfffffff0,%edx
8010835f:	83 ca 02             	or     $0x2,%edx
80108362:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108372:	83 ca 10             	or     $0x10,%edx
80108375:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010837b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108385:	83 e2 9f             	and    $0xffffff9f,%edx
80108388:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010838e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108391:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108398:	83 ca 80             	or     $0xffffff80,%edx
8010839b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801083a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083ab:	83 e2 f0             	and    $0xfffffff0,%edx
801083ae:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083be:	83 e2 ef             	and    $0xffffffef,%edx
801083c1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ca:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083d1:	83 e2 df             	and    $0xffffffdf,%edx
801083d4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083dd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083e4:	83 ca 40             	or     $0x40,%edx
801083e7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083f7:	83 ca 80             	or     $0xffffff80,%edx
801083fa:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108403:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840c:	83 c0 70             	add    $0x70,%eax
8010840f:	83 ec 08             	sub    $0x8,%esp
80108412:	6a 38                	push   $0x38
80108414:	50                   	push   %eax
80108415:	e8 38 fb ff ff       	call   80107f52 <lgdt>
8010841a:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010841d:	83 ec 0c             	sub    $0xc,%esp
80108420:	6a 18                	push   $0x18
80108422:	e8 6c fb ff ff       	call   80107f93 <loadgs>
80108427:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010842a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842d:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108433:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010843a:	00 00 00 00 
}
8010843e:	90                   	nop
8010843f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108442:	c9                   	leave  
80108443:	c3                   	ret    

80108444 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108444:	55                   	push   %ebp
80108445:	89 e5                	mov    %esp,%ebp
80108447:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010844a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010844d:	c1 e8 16             	shr    $0x16,%eax
80108450:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108457:	8b 45 08             	mov    0x8(%ebp),%eax
8010845a:	01 d0                	add    %edx,%eax
8010845c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010845f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108462:	8b 00                	mov    (%eax),%eax
80108464:	83 e0 01             	and    $0x1,%eax
80108467:	85 c0                	test   %eax,%eax
80108469:	74 18                	je     80108483 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010846b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010846e:	8b 00                	mov    (%eax),%eax
80108470:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108475:	50                   	push   %eax
80108476:	e8 47 fb ff ff       	call   80107fc2 <p2v>
8010847b:	83 c4 04             	add    $0x4,%esp
8010847e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108481:	eb 48                	jmp    801084cb <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108483:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108487:	74 0e                	je     80108497 <walkpgdir+0x53>
80108489:	e8 ae aa ff ff       	call   80102f3c <kalloc>
8010848e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108495:	75 07                	jne    8010849e <walkpgdir+0x5a>
      return 0;
80108497:	b8 00 00 00 00       	mov    $0x0,%eax
8010849c:	eb 44                	jmp    801084e2 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010849e:	83 ec 04             	sub    $0x4,%esp
801084a1:	68 00 10 00 00       	push   $0x1000
801084a6:	6a 00                	push   $0x0
801084a8:	ff 75 f4             	pushl  -0xc(%ebp)
801084ab:	e8 9d d0 ff ff       	call   8010554d <memset>
801084b0:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801084b3:	83 ec 0c             	sub    $0xc,%esp
801084b6:	ff 75 f4             	pushl  -0xc(%ebp)
801084b9:	e8 f7 fa ff ff       	call   80107fb5 <v2p>
801084be:	83 c4 10             	add    $0x10,%esp
801084c1:	83 c8 07             	or     $0x7,%eax
801084c4:	89 c2                	mov    %eax,%edx
801084c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084c9:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801084cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801084ce:	c1 e8 0c             	shr    $0xc,%eax
801084d1:	25 ff 03 00 00       	and    $0x3ff,%eax
801084d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801084dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e0:	01 d0                	add    %edx,%eax
}
801084e2:	c9                   	leave  
801084e3:	c3                   	ret    

801084e4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801084e4:	55                   	push   %ebp
801084e5:	89 e5                	mov    %esp,%ebp
801084e7:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801084ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801084ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801084f5:	8b 55 0c             	mov    0xc(%ebp),%edx
801084f8:	8b 45 10             	mov    0x10(%ebp),%eax
801084fb:	01 d0                	add    %edx,%eax
801084fd:	83 e8 01             	sub    $0x1,%eax
80108500:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108505:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108508:	83 ec 04             	sub    $0x4,%esp
8010850b:	6a 01                	push   $0x1
8010850d:	ff 75 f4             	pushl  -0xc(%ebp)
80108510:	ff 75 08             	pushl  0x8(%ebp)
80108513:	e8 2c ff ff ff       	call   80108444 <walkpgdir>
80108518:	83 c4 10             	add    $0x10,%esp
8010851b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010851e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108522:	75 07                	jne    8010852b <mappages+0x47>
      return -1;
80108524:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108529:	eb 47                	jmp    80108572 <mappages+0x8e>
    if(*pte & PTE_P)
8010852b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010852e:	8b 00                	mov    (%eax),%eax
80108530:	83 e0 01             	and    $0x1,%eax
80108533:	85 c0                	test   %eax,%eax
80108535:	74 0d                	je     80108544 <mappages+0x60>
      panic("remap");
80108537:	83 ec 0c             	sub    $0xc,%esp
8010853a:	68 90 93 10 80       	push   $0x80109390
8010853f:	e8 22 80 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108544:	8b 45 18             	mov    0x18(%ebp),%eax
80108547:	0b 45 14             	or     0x14(%ebp),%eax
8010854a:	83 c8 01             	or     $0x1,%eax
8010854d:	89 c2                	mov    %eax,%edx
8010854f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108552:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108557:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010855a:	74 10                	je     8010856c <mappages+0x88>
      break;
    a += PGSIZE;
8010855c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108563:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010856a:	eb 9c                	jmp    80108508 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
8010856c:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010856d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108572:	c9                   	leave  
80108573:	c3                   	ret    

80108574 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108574:	55                   	push   %ebp
80108575:	89 e5                	mov    %esp,%ebp
80108577:	53                   	push   %ebx
80108578:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010857b:	e8 bc a9 ff ff       	call   80102f3c <kalloc>
80108580:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108583:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108587:	75 0a                	jne    80108593 <setupkvm+0x1f>
    return 0;
80108589:	b8 00 00 00 00       	mov    $0x0,%eax
8010858e:	e9 8e 00 00 00       	jmp    80108621 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108593:	83 ec 04             	sub    $0x4,%esp
80108596:	68 00 10 00 00       	push   $0x1000
8010859b:	6a 00                	push   $0x0
8010859d:	ff 75 f0             	pushl  -0x10(%ebp)
801085a0:	e8 a8 cf ff ff       	call   8010554d <memset>
801085a5:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801085a8:	83 ec 0c             	sub    $0xc,%esp
801085ab:	68 00 00 00 0e       	push   $0xe000000
801085b0:	e8 0d fa ff ff       	call   80107fc2 <p2v>
801085b5:	83 c4 10             	add    $0x10,%esp
801085b8:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801085bd:	76 0d                	jbe    801085cc <setupkvm+0x58>
    panic("PHYSTOP too high");
801085bf:	83 ec 0c             	sub    $0xc,%esp
801085c2:	68 96 93 10 80       	push   $0x80109396
801085c7:	e8 9a 7f ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085cc:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
801085d3:	eb 40                	jmp    80108615 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801085d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d8:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801085db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085de:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801085e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e4:	8b 58 08             	mov    0x8(%eax),%ebx
801085e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ea:	8b 40 04             	mov    0x4(%eax),%eax
801085ed:	29 c3                	sub    %eax,%ebx
801085ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f2:	8b 00                	mov    (%eax),%eax
801085f4:	83 ec 0c             	sub    $0xc,%esp
801085f7:	51                   	push   %ecx
801085f8:	52                   	push   %edx
801085f9:	53                   	push   %ebx
801085fa:	50                   	push   %eax
801085fb:	ff 75 f0             	pushl  -0x10(%ebp)
801085fe:	e8 e1 fe ff ff       	call   801084e4 <mappages>
80108603:	83 c4 20             	add    $0x20,%esp
80108606:	85 c0                	test   %eax,%eax
80108608:	79 07                	jns    80108611 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010860a:	b8 00 00 00 00       	mov    $0x0,%eax
8010860f:	eb 10                	jmp    80108621 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108611:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108615:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
8010861c:	72 b7                	jb     801085d5 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010861e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108621:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108624:	c9                   	leave  
80108625:	c3                   	ret    

80108626 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108626:	55                   	push   %ebp
80108627:	89 e5                	mov    %esp,%ebp
80108629:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010862c:	e8 43 ff ff ff       	call   80108574 <setupkvm>
80108631:	a3 58 66 11 80       	mov    %eax,0x80116658
  switchkvm();
80108636:	e8 03 00 00 00       	call   8010863e <switchkvm>
}
8010863b:	90                   	nop
8010863c:	c9                   	leave  
8010863d:	c3                   	ret    

8010863e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010863e:	55                   	push   %ebp
8010863f:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108641:	a1 58 66 11 80       	mov    0x80116658,%eax
80108646:	50                   	push   %eax
80108647:	e8 69 f9 ff ff       	call   80107fb5 <v2p>
8010864c:	83 c4 04             	add    $0x4,%esp
8010864f:	50                   	push   %eax
80108650:	e8 54 f9 ff ff       	call   80107fa9 <lcr3>
80108655:	83 c4 04             	add    $0x4,%esp
}
80108658:	90                   	nop
80108659:	c9                   	leave  
8010865a:	c3                   	ret    

8010865b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010865b:	55                   	push   %ebp
8010865c:	89 e5                	mov    %esp,%ebp
8010865e:	56                   	push   %esi
8010865f:	53                   	push   %ebx
  pushcli();
80108660:	e8 e2 cd ff ff       	call   80105447 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108665:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010866b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108672:	83 c2 08             	add    $0x8,%edx
80108675:	89 d6                	mov    %edx,%esi
80108677:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010867e:	83 c2 08             	add    $0x8,%edx
80108681:	c1 ea 10             	shr    $0x10,%edx
80108684:	89 d3                	mov    %edx,%ebx
80108686:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010868d:	83 c2 08             	add    $0x8,%edx
80108690:	c1 ea 18             	shr    $0x18,%edx
80108693:	89 d1                	mov    %edx,%ecx
80108695:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010869c:	67 00 
8010869e:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801086a5:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801086ab:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086b2:	83 e2 f0             	and    $0xfffffff0,%edx
801086b5:	83 ca 09             	or     $0x9,%edx
801086b8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086be:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086c5:	83 ca 10             	or     $0x10,%edx
801086c8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086ce:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086d5:	83 e2 9f             	and    $0xffffff9f,%edx
801086d8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086de:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086e5:	83 ca 80             	or     $0xffffff80,%edx
801086e8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086ee:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801086f5:	83 e2 f0             	and    $0xfffffff0,%edx
801086f8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086fe:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108705:	83 e2 ef             	and    $0xffffffef,%edx
80108708:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010870e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108715:	83 e2 df             	and    $0xffffffdf,%edx
80108718:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010871e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108725:	83 ca 40             	or     $0x40,%edx
80108728:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010872e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108735:	83 e2 7f             	and    $0x7f,%edx
80108738:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010873e:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108744:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010874a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108751:	83 e2 ef             	and    $0xffffffef,%edx
80108754:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010875a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108760:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108766:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010876c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108773:	8b 52 08             	mov    0x8(%edx),%edx
80108776:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010877c:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010877f:	83 ec 0c             	sub    $0xc,%esp
80108782:	6a 30                	push   $0x30
80108784:	e8 f3 f7 ff ff       	call   80107f7c <ltr>
80108789:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010878c:	8b 45 08             	mov    0x8(%ebp),%eax
8010878f:	8b 40 04             	mov    0x4(%eax),%eax
80108792:	85 c0                	test   %eax,%eax
80108794:	75 0d                	jne    801087a3 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108796:	83 ec 0c             	sub    $0xc,%esp
80108799:	68 a7 93 10 80       	push   $0x801093a7
8010879e:	e8 c3 7d ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801087a3:	8b 45 08             	mov    0x8(%ebp),%eax
801087a6:	8b 40 04             	mov    0x4(%eax),%eax
801087a9:	83 ec 0c             	sub    $0xc,%esp
801087ac:	50                   	push   %eax
801087ad:	e8 03 f8 ff ff       	call   80107fb5 <v2p>
801087b2:	83 c4 10             	add    $0x10,%esp
801087b5:	83 ec 0c             	sub    $0xc,%esp
801087b8:	50                   	push   %eax
801087b9:	e8 eb f7 ff ff       	call   80107fa9 <lcr3>
801087be:	83 c4 10             	add    $0x10,%esp
  popcli();
801087c1:	e8 c6 cc ff ff       	call   8010548c <popcli>
}
801087c6:	90                   	nop
801087c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801087ca:	5b                   	pop    %ebx
801087cb:	5e                   	pop    %esi
801087cc:	5d                   	pop    %ebp
801087cd:	c3                   	ret    

801087ce <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801087ce:	55                   	push   %ebp
801087cf:	89 e5                	mov    %esp,%ebp
801087d1:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801087d4:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801087db:	76 0d                	jbe    801087ea <inituvm+0x1c>
    panic("inituvm: more than a page");
801087dd:	83 ec 0c             	sub    $0xc,%esp
801087e0:	68 bb 93 10 80       	push   $0x801093bb
801087e5:	e8 7c 7d ff ff       	call   80100566 <panic>
  mem = kalloc();
801087ea:	e8 4d a7 ff ff       	call   80102f3c <kalloc>
801087ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801087f2:	83 ec 04             	sub    $0x4,%esp
801087f5:	68 00 10 00 00       	push   $0x1000
801087fa:	6a 00                	push   $0x0
801087fc:	ff 75 f4             	pushl  -0xc(%ebp)
801087ff:	e8 49 cd ff ff       	call   8010554d <memset>
80108804:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108807:	83 ec 0c             	sub    $0xc,%esp
8010880a:	ff 75 f4             	pushl  -0xc(%ebp)
8010880d:	e8 a3 f7 ff ff       	call   80107fb5 <v2p>
80108812:	83 c4 10             	add    $0x10,%esp
80108815:	83 ec 0c             	sub    $0xc,%esp
80108818:	6a 06                	push   $0x6
8010881a:	50                   	push   %eax
8010881b:	68 00 10 00 00       	push   $0x1000
80108820:	6a 00                	push   $0x0
80108822:	ff 75 08             	pushl  0x8(%ebp)
80108825:	e8 ba fc ff ff       	call   801084e4 <mappages>
8010882a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010882d:	83 ec 04             	sub    $0x4,%esp
80108830:	ff 75 10             	pushl  0x10(%ebp)
80108833:	ff 75 0c             	pushl  0xc(%ebp)
80108836:	ff 75 f4             	pushl  -0xc(%ebp)
80108839:	e8 ce cd ff ff       	call   8010560c <memmove>
8010883e:	83 c4 10             	add    $0x10,%esp
}
80108841:	90                   	nop
80108842:	c9                   	leave  
80108843:	c3                   	ret    

80108844 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108844:	55                   	push   %ebp
80108845:	89 e5                	mov    %esp,%ebp
80108847:	53                   	push   %ebx
80108848:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010884b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010884e:	25 ff 0f 00 00       	and    $0xfff,%eax
80108853:	85 c0                	test   %eax,%eax
80108855:	74 0d                	je     80108864 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108857:	83 ec 0c             	sub    $0xc,%esp
8010885a:	68 d8 93 10 80       	push   $0x801093d8
8010885f:	e8 02 7d ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108864:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010886b:	e9 95 00 00 00       	jmp    80108905 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108870:	8b 55 0c             	mov    0xc(%ebp),%edx
80108873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108876:	01 d0                	add    %edx,%eax
80108878:	83 ec 04             	sub    $0x4,%esp
8010887b:	6a 00                	push   $0x0
8010887d:	50                   	push   %eax
8010887e:	ff 75 08             	pushl  0x8(%ebp)
80108881:	e8 be fb ff ff       	call   80108444 <walkpgdir>
80108886:	83 c4 10             	add    $0x10,%esp
80108889:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010888c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108890:	75 0d                	jne    8010889f <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108892:	83 ec 0c             	sub    $0xc,%esp
80108895:	68 fb 93 10 80       	push   $0x801093fb
8010889a:	e8 c7 7c ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010889f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088a2:	8b 00                	mov    (%eax),%eax
801088a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801088ac:	8b 45 18             	mov    0x18(%ebp),%eax
801088af:	2b 45 f4             	sub    -0xc(%ebp),%eax
801088b2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801088b7:	77 0b                	ja     801088c4 <loaduvm+0x80>
      n = sz - i;
801088b9:	8b 45 18             	mov    0x18(%ebp),%eax
801088bc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801088bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801088c2:	eb 07                	jmp    801088cb <loaduvm+0x87>
    else
      n = PGSIZE;
801088c4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801088cb:	8b 55 14             	mov    0x14(%ebp),%edx
801088ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801088d4:	83 ec 0c             	sub    $0xc,%esp
801088d7:	ff 75 e8             	pushl  -0x18(%ebp)
801088da:	e8 e3 f6 ff ff       	call   80107fc2 <p2v>
801088df:	83 c4 10             	add    $0x10,%esp
801088e2:	ff 75 f0             	pushl  -0x10(%ebp)
801088e5:	53                   	push   %ebx
801088e6:	50                   	push   %eax
801088e7:	ff 75 10             	pushl  0x10(%ebp)
801088ea:	e8 bf 98 ff ff       	call   801021ae <readi>
801088ef:	83 c4 10             	add    $0x10,%esp
801088f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801088f5:	74 07                	je     801088fe <loaduvm+0xba>
      return -1;
801088f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088fc:	eb 18                	jmp    80108916 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801088fe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108908:	3b 45 18             	cmp    0x18(%ebp),%eax
8010890b:	0f 82 5f ff ff ff    	jb     80108870 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108911:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108919:	c9                   	leave  
8010891a:	c3                   	ret    

8010891b <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010891b:	55                   	push   %ebp
8010891c:	89 e5                	mov    %esp,%ebp
8010891e:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108921:	8b 45 10             	mov    0x10(%ebp),%eax
80108924:	85 c0                	test   %eax,%eax
80108926:	79 0a                	jns    80108932 <allocuvm+0x17>
    return 0;
80108928:	b8 00 00 00 00       	mov    $0x0,%eax
8010892d:	e9 b0 00 00 00       	jmp    801089e2 <allocuvm+0xc7>
  if(newsz < oldsz)
80108932:	8b 45 10             	mov    0x10(%ebp),%eax
80108935:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108938:	73 08                	jae    80108942 <allocuvm+0x27>
    return oldsz;
8010893a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010893d:	e9 a0 00 00 00       	jmp    801089e2 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108942:	8b 45 0c             	mov    0xc(%ebp),%eax
80108945:	05 ff 0f 00 00       	add    $0xfff,%eax
8010894a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010894f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108952:	eb 7f                	jmp    801089d3 <allocuvm+0xb8>
    mem = kalloc();
80108954:	e8 e3 a5 ff ff       	call   80102f3c <kalloc>
80108959:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010895c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108960:	75 2b                	jne    8010898d <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108962:	83 ec 0c             	sub    $0xc,%esp
80108965:	68 19 94 10 80       	push   $0x80109419
8010896a:	e8 57 7a ff ff       	call   801003c6 <cprintf>
8010896f:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108972:	83 ec 04             	sub    $0x4,%esp
80108975:	ff 75 0c             	pushl  0xc(%ebp)
80108978:	ff 75 10             	pushl  0x10(%ebp)
8010897b:	ff 75 08             	pushl  0x8(%ebp)
8010897e:	e8 61 00 00 00       	call   801089e4 <deallocuvm>
80108983:	83 c4 10             	add    $0x10,%esp
      return 0;
80108986:	b8 00 00 00 00       	mov    $0x0,%eax
8010898b:	eb 55                	jmp    801089e2 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
8010898d:	83 ec 04             	sub    $0x4,%esp
80108990:	68 00 10 00 00       	push   $0x1000
80108995:	6a 00                	push   $0x0
80108997:	ff 75 f0             	pushl  -0x10(%ebp)
8010899a:	e8 ae cb ff ff       	call   8010554d <memset>
8010899f:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801089a2:	83 ec 0c             	sub    $0xc,%esp
801089a5:	ff 75 f0             	pushl  -0x10(%ebp)
801089a8:	e8 08 f6 ff ff       	call   80107fb5 <v2p>
801089ad:	83 c4 10             	add    $0x10,%esp
801089b0:	89 c2                	mov    %eax,%edx
801089b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b5:	83 ec 0c             	sub    $0xc,%esp
801089b8:	6a 06                	push   $0x6
801089ba:	52                   	push   %edx
801089bb:	68 00 10 00 00       	push   $0x1000
801089c0:	50                   	push   %eax
801089c1:	ff 75 08             	pushl  0x8(%ebp)
801089c4:	e8 1b fb ff ff       	call   801084e4 <mappages>
801089c9:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801089cc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089d6:	3b 45 10             	cmp    0x10(%ebp),%eax
801089d9:	0f 82 75 ff ff ff    	jb     80108954 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801089df:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089e2:	c9                   	leave  
801089e3:	c3                   	ret    

801089e4 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801089e4:	55                   	push   %ebp
801089e5:	89 e5                	mov    %esp,%ebp
801089e7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801089ea:	8b 45 10             	mov    0x10(%ebp),%eax
801089ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089f0:	72 08                	jb     801089fa <deallocuvm+0x16>
    return oldsz;
801089f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801089f5:	e9 a5 00 00 00       	jmp    80108a9f <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801089fa:	8b 45 10             	mov    0x10(%ebp),%eax
801089fd:	05 ff 0f 00 00       	add    $0xfff,%eax
80108a02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108a0a:	e9 81 00 00 00       	jmp    80108a90 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a12:	83 ec 04             	sub    $0x4,%esp
80108a15:	6a 00                	push   $0x0
80108a17:	50                   	push   %eax
80108a18:	ff 75 08             	pushl  0x8(%ebp)
80108a1b:	e8 24 fa ff ff       	call   80108444 <walkpgdir>
80108a20:	83 c4 10             	add    $0x10,%esp
80108a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108a26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a2a:	75 09                	jne    80108a35 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108a2c:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108a33:	eb 54                	jmp    80108a89 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a38:	8b 00                	mov    (%eax),%eax
80108a3a:	83 e0 01             	and    $0x1,%eax
80108a3d:	85 c0                	test   %eax,%eax
80108a3f:	74 48                	je     80108a89 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a44:	8b 00                	mov    (%eax),%eax
80108a46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108a4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a52:	75 0d                	jne    80108a61 <deallocuvm+0x7d>
        panic("kfree");
80108a54:	83 ec 0c             	sub    $0xc,%esp
80108a57:	68 31 94 10 80       	push   $0x80109431
80108a5c:	e8 05 7b ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108a61:	83 ec 0c             	sub    $0xc,%esp
80108a64:	ff 75 ec             	pushl  -0x14(%ebp)
80108a67:	e8 56 f5 ff ff       	call   80107fc2 <p2v>
80108a6c:	83 c4 10             	add    $0x10,%esp
80108a6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108a72:	83 ec 0c             	sub    $0xc,%esp
80108a75:	ff 75 e8             	pushl  -0x18(%ebp)
80108a78:	e8 22 a4 ff ff       	call   80102e9f <kfree>
80108a7d:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108a89:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a93:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a96:	0f 82 73 ff ff ff    	jb     80108a0f <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108a9c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108a9f:	c9                   	leave  
80108aa0:	c3                   	ret    

80108aa1 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108aa1:	55                   	push   %ebp
80108aa2:	89 e5                	mov    %esp,%ebp
80108aa4:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108aa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108aab:	75 0d                	jne    80108aba <freevm+0x19>
    panic("freevm: no pgdir");
80108aad:	83 ec 0c             	sub    $0xc,%esp
80108ab0:	68 37 94 10 80       	push   $0x80109437
80108ab5:	e8 ac 7a ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108aba:	83 ec 04             	sub    $0x4,%esp
80108abd:	6a 00                	push   $0x0
80108abf:	68 00 00 00 80       	push   $0x80000000
80108ac4:	ff 75 08             	pushl  0x8(%ebp)
80108ac7:	e8 18 ff ff ff       	call   801089e4 <deallocuvm>
80108acc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108acf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ad6:	eb 4f                	jmp    80108b27 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108adb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80108ae5:	01 d0                	add    %edx,%eax
80108ae7:	8b 00                	mov    (%eax),%eax
80108ae9:	83 e0 01             	and    $0x1,%eax
80108aec:	85 c0                	test   %eax,%eax
80108aee:	74 33                	je     80108b23 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108afa:	8b 45 08             	mov    0x8(%ebp),%eax
80108afd:	01 d0                	add    %edx,%eax
80108aff:	8b 00                	mov    (%eax),%eax
80108b01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b06:	83 ec 0c             	sub    $0xc,%esp
80108b09:	50                   	push   %eax
80108b0a:	e8 b3 f4 ff ff       	call   80107fc2 <p2v>
80108b0f:	83 c4 10             	add    $0x10,%esp
80108b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108b15:	83 ec 0c             	sub    $0xc,%esp
80108b18:	ff 75 f0             	pushl  -0x10(%ebp)
80108b1b:	e8 7f a3 ff ff       	call   80102e9f <kfree>
80108b20:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108b23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b27:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108b2e:	76 a8                	jbe    80108ad8 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108b30:	83 ec 0c             	sub    $0xc,%esp
80108b33:	ff 75 08             	pushl  0x8(%ebp)
80108b36:	e8 64 a3 ff ff       	call   80102e9f <kfree>
80108b3b:	83 c4 10             	add    $0x10,%esp
}
80108b3e:	90                   	nop
80108b3f:	c9                   	leave  
80108b40:	c3                   	ret    

80108b41 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108b41:	55                   	push   %ebp
80108b42:	89 e5                	mov    %esp,%ebp
80108b44:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b47:	83 ec 04             	sub    $0x4,%esp
80108b4a:	6a 00                	push   $0x0
80108b4c:	ff 75 0c             	pushl  0xc(%ebp)
80108b4f:	ff 75 08             	pushl  0x8(%ebp)
80108b52:	e8 ed f8 ff ff       	call   80108444 <walkpgdir>
80108b57:	83 c4 10             	add    $0x10,%esp
80108b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108b61:	75 0d                	jne    80108b70 <clearpteu+0x2f>
    panic("clearpteu");
80108b63:	83 ec 0c             	sub    $0xc,%esp
80108b66:	68 48 94 10 80       	push   $0x80109448
80108b6b:	e8 f6 79 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b73:	8b 00                	mov    (%eax),%eax
80108b75:	83 e0 fb             	and    $0xfffffffb,%eax
80108b78:	89 c2                	mov    %eax,%edx
80108b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b7d:	89 10                	mov    %edx,(%eax)
}
80108b7f:	90                   	nop
80108b80:	c9                   	leave  
80108b81:	c3                   	ret    

80108b82 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b82:	55                   	push   %ebp
80108b83:	89 e5                	mov    %esp,%ebp
80108b85:	53                   	push   %ebx
80108b86:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108b89:	e8 e6 f9 ff ff       	call   80108574 <setupkvm>
80108b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b95:	75 0a                	jne    80108ba1 <copyuvm+0x1f>
    return 0;
80108b97:	b8 00 00 00 00       	mov    $0x0,%eax
80108b9c:	e9 f8 00 00 00       	jmp    80108c99 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108ba1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ba8:	e9 c4 00 00 00       	jmp    80108c71 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bb0:	83 ec 04             	sub    $0x4,%esp
80108bb3:	6a 00                	push   $0x0
80108bb5:	50                   	push   %eax
80108bb6:	ff 75 08             	pushl  0x8(%ebp)
80108bb9:	e8 86 f8 ff ff       	call   80108444 <walkpgdir>
80108bbe:	83 c4 10             	add    $0x10,%esp
80108bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108bc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108bc8:	75 0d                	jne    80108bd7 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108bca:	83 ec 0c             	sub    $0xc,%esp
80108bcd:	68 52 94 10 80       	push   $0x80109452
80108bd2:	e8 8f 79 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bda:	8b 00                	mov    (%eax),%eax
80108bdc:	83 e0 01             	and    $0x1,%eax
80108bdf:	85 c0                	test   %eax,%eax
80108be1:	75 0d                	jne    80108bf0 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108be3:	83 ec 0c             	sub    $0xc,%esp
80108be6:	68 6c 94 10 80       	push   $0x8010946c
80108beb:	e8 76 79 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bf3:	8b 00                	mov    (%eax),%eax
80108bf5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c00:	8b 00                	mov    (%eax),%eax
80108c02:	25 ff 0f 00 00       	and    $0xfff,%eax
80108c07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108c0a:	e8 2d a3 ff ff       	call   80102f3c <kalloc>
80108c0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108c12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108c16:	74 6a                	je     80108c82 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108c18:	83 ec 0c             	sub    $0xc,%esp
80108c1b:	ff 75 e8             	pushl  -0x18(%ebp)
80108c1e:	e8 9f f3 ff ff       	call   80107fc2 <p2v>
80108c23:	83 c4 10             	add    $0x10,%esp
80108c26:	83 ec 04             	sub    $0x4,%esp
80108c29:	68 00 10 00 00       	push   $0x1000
80108c2e:	50                   	push   %eax
80108c2f:	ff 75 e0             	pushl  -0x20(%ebp)
80108c32:	e8 d5 c9 ff ff       	call   8010560c <memmove>
80108c37:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108c3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108c3d:	83 ec 0c             	sub    $0xc,%esp
80108c40:	ff 75 e0             	pushl  -0x20(%ebp)
80108c43:	e8 6d f3 ff ff       	call   80107fb5 <v2p>
80108c48:	83 c4 10             	add    $0x10,%esp
80108c4b:	89 c2                	mov    %eax,%edx
80108c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c50:	83 ec 0c             	sub    $0xc,%esp
80108c53:	53                   	push   %ebx
80108c54:	52                   	push   %edx
80108c55:	68 00 10 00 00       	push   $0x1000
80108c5a:	50                   	push   %eax
80108c5b:	ff 75 f0             	pushl  -0x10(%ebp)
80108c5e:	e8 81 f8 ff ff       	call   801084e4 <mappages>
80108c63:	83 c4 20             	add    $0x20,%esp
80108c66:	85 c0                	test   %eax,%eax
80108c68:	78 1b                	js     80108c85 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108c6a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c74:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c77:	0f 82 30 ff ff ff    	jb     80108bad <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c80:	eb 17                	jmp    80108c99 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108c82:	90                   	nop
80108c83:	eb 01                	jmp    80108c86 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108c85:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108c86:	83 ec 0c             	sub    $0xc,%esp
80108c89:	ff 75 f0             	pushl  -0x10(%ebp)
80108c8c:	e8 10 fe ff ff       	call   80108aa1 <freevm>
80108c91:	83 c4 10             	add    $0x10,%esp
  return 0;
80108c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108c9c:	c9                   	leave  
80108c9d:	c3                   	ret    

80108c9e <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108c9e:	55                   	push   %ebp
80108c9f:	89 e5                	mov    %esp,%ebp
80108ca1:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108ca4:	83 ec 04             	sub    $0x4,%esp
80108ca7:	6a 00                	push   $0x0
80108ca9:	ff 75 0c             	pushl  0xc(%ebp)
80108cac:	ff 75 08             	pushl  0x8(%ebp)
80108caf:	e8 90 f7 ff ff       	call   80108444 <walkpgdir>
80108cb4:	83 c4 10             	add    $0x10,%esp
80108cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cbd:	8b 00                	mov    (%eax),%eax
80108cbf:	83 e0 01             	and    $0x1,%eax
80108cc2:	85 c0                	test   %eax,%eax
80108cc4:	75 07                	jne    80108ccd <uva2ka+0x2f>
    return 0;
80108cc6:	b8 00 00 00 00       	mov    $0x0,%eax
80108ccb:	eb 29                	jmp    80108cf6 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd0:	8b 00                	mov    (%eax),%eax
80108cd2:	83 e0 04             	and    $0x4,%eax
80108cd5:	85 c0                	test   %eax,%eax
80108cd7:	75 07                	jne    80108ce0 <uva2ka+0x42>
    return 0;
80108cd9:	b8 00 00 00 00       	mov    $0x0,%eax
80108cde:	eb 16                	jmp    80108cf6 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce3:	8b 00                	mov    (%eax),%eax
80108ce5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cea:	83 ec 0c             	sub    $0xc,%esp
80108ced:	50                   	push   %eax
80108cee:	e8 cf f2 ff ff       	call   80107fc2 <p2v>
80108cf3:	83 c4 10             	add    $0x10,%esp
}
80108cf6:	c9                   	leave  
80108cf7:	c3                   	ret    

80108cf8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108cf8:	55                   	push   %ebp
80108cf9:	89 e5                	mov    %esp,%ebp
80108cfb:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108cfe:	8b 45 10             	mov    0x10(%ebp),%eax
80108d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108d04:	eb 7f                	jmp    80108d85 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108d06:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d14:	83 ec 08             	sub    $0x8,%esp
80108d17:	50                   	push   %eax
80108d18:	ff 75 08             	pushl  0x8(%ebp)
80108d1b:	e8 7e ff ff ff       	call   80108c9e <uva2ka>
80108d20:	83 c4 10             	add    $0x10,%esp
80108d23:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108d26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108d2a:	75 07                	jne    80108d33 <copyout+0x3b>
      return -1;
80108d2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d31:	eb 61                	jmp    80108d94 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108d33:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d36:	2b 45 0c             	sub    0xc(%ebp),%eax
80108d39:	05 00 10 00 00       	add    $0x1000,%eax
80108d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d44:	3b 45 14             	cmp    0x14(%ebp),%eax
80108d47:	76 06                	jbe    80108d4f <copyout+0x57>
      n = len;
80108d49:	8b 45 14             	mov    0x14(%ebp),%eax
80108d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d52:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108d55:	89 c2                	mov    %eax,%edx
80108d57:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d5a:	01 d0                	add    %edx,%eax
80108d5c:	83 ec 04             	sub    $0x4,%esp
80108d5f:	ff 75 f0             	pushl  -0x10(%ebp)
80108d62:	ff 75 f4             	pushl  -0xc(%ebp)
80108d65:	50                   	push   %eax
80108d66:	e8 a1 c8 ff ff       	call   8010560c <memmove>
80108d6b:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d71:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d77:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d7d:	05 00 10 00 00       	add    $0x1000,%eax
80108d82:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108d85:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108d89:	0f 85 77 ff ff ff    	jne    80108d06 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d94:	c9                   	leave  
80108d95:	c3                   	ret    
