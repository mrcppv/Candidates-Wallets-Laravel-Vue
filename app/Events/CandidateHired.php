<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use App\Models\Candidate;

class CandidateHired implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $candidateId;
    public $coins;

    public function __construct($candidateId, $coins)
    {
        $this->candidateId = $candidateId;
        $this->coins = $coins;
    }

    public function broadcastOn()
    {
        return new Channel('candidates');
    }

    public function broadcastWith()
    {
        return [
            'candidateId' => $this->candidateId,
            'coins' => $this->coins,
        ];
    }
}
